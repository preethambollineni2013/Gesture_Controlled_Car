/*
  GESTURE CAR - TRANSMITTER  (ESP32 DevKit + BNO055)      rev B
  Board: "ESP32 Dev Module".  No extra libraries needed.

  Wiring: BNO055 VIN->3V3, GND->GND, SDA->GPIO21, SCL->GPIO22.
  Power on with your hand held LEVEL and STILL: that pose becomes neutral.
  Press the BOOT button (GPIO0) to re-zero.  Do not hold BOOT while powering on.

  Wrist up/down    -> forward/reverse (speed grows with tilt)
  Wrist left/right -> turn left/right
  On-board LED: solid = a car is connected, off = no car.
*/
#include <Wire.h>
#include <WiFi.h>
#include <WiFiUdp.h>
#include <esp_wifi.h>
#include <math.h>

// ---------------- settings ----------------
static const char     WIFI_SSID[] = "GestureCar";
static const char     WIFI_PASS[] = "car12345pass";   // 8+ characters, identical on the car
static const uint16_t PORT        = 4210;
static const uint8_t  BNO_ADDR    = 0x28;             // 0x29 if the ADR pin is high
static const uint32_t I2C_HZ      = 100000;           // BNO055 stretches the clock: 100 kHz is the reliable speed on ESP32
static const bool  SWAP_AXES    = false;              // true if forward/back tilt shows up as roll
static const bool  INV_THROTTLE = false;              // flip if wrist-up drives backwards
static const bool  INV_STEER    = false;              // flip if tilting right turns left
static const float DEAD_DEG     = 8.0f;               // no command inside +/- this angle
static const float FULL_DEG     = 40.0f;              // full command at this angle
static const uint8_t PIN_BTN    = 0;                  // BOOT button
static const uint8_t PIN_LED    = 2;
#define DEBUG 0

static const IPAddress CAR_IP(192, 168, 4, 50);       // fixed address of the car
static WiFiUDP udp;

struct __attribute__((packed)) Pkt { uint8_t magic; int8_t thr; int8_t str; uint8_t chk; };

// ---------------- minimal BNO055 driver ----------------
static bool bnoWrite(uint8_t reg, uint8_t v) {
  Wire.beginTransmission(BNO_ADDR); Wire.write(reg); Wire.write(v);
  return Wire.endTransmission() == 0;
}
static bool bnoRead(uint8_t reg, uint8_t *b, uint8_t n) {
  Wire.beginTransmission(BNO_ADDR); Wire.write(reg);
  if (Wire.endTransmission(false) != 0) return false;
  if (Wire.requestFrom((uint8_t)BNO_ADDR, (uint8_t)n) != n) return false;
  for (uint8_t i = 0; i < n; i++) b[i] = Wire.read();
  return true;
}
static bool bnoInit() {
  for (uint8_t tries = 0; tries < 10; tries++) {
    uint8_t id = 0;
    if (bnoRead(0x00, &id, 1) && id == 0xA0) {
      bnoWrite(0x3D, 0x00); delay(25);            // CONFIG mode
      bnoWrite(0x3F, 0x20); delay(700);           // reset (chip is silent for ~650 ms)
      uint32_t t = millis();
      while (!(bnoRead(0x00, &id, 1) && id == 0xA0)) { if (millis() - t > 1500) return false; delay(20); }
      bnoWrite(0x3E, 0x00); delay(10);            // normal power
      bnoWrite(0x07, 0x00);                       // register page 0
      bnoWrite(0x3F, 0x80); delay(10);            // external crystal
      bnoWrite(0x3D, 0x08); delay(25);            // IMUPLUS: accel+gyro fusion, 100 Hz, no magnetometer
      return true;
    }
    delay(100);
  }
  return false;
}
// 1 = ok, 0 = I2C error, -1 = sensor answered but is not in IMUPLUS mode (it reset itself, e.g. brown-out)
static int8_t readAngles(float &roll, float &pitch) {
  uint8_t m, b[4];
  if (!bnoRead(0x3D, &m, 1)) return 0;
  if ((m & 0x0F) != 0x08) return -1;                  // a reset sensor would report 0 degrees: never trust it
  if (!bnoRead(0x1C, b, 4)) return 0;
  roll  = (int16_t)(b[0] | (b[1] << 8)) / 16.0f;      // degrees (16 LSB per degree)
  pitch = (int16_t)(b[2] | (b[3] << 8)) / 16.0f;
  return 1;
}

// ---------------- helpers ----------------
static float wrap180(float a) { while (a > 180) a -= 360; while (a < -180) a += 360; return a; }
static float zeroFwd = 0, zeroSide = 0;

static void pick(float r, float p, float &fwd, float &side) {
  fwd  = SWAP_AXES ? r : p;
  side = SWAP_AXES ? p : r;
}

// Neutral = average of 0.8 s during which the hand moved less than 2 degrees (gives up after 8 s).
static void zeroNow() {
  const int N = 40;
  float fs[N], ss[N];
  int n = 0;
  uint32_t t0 = millis();
  digitalWrite(PIN_LED, HIGH);
  for (;;) {
    float r, p, f, s;
    if (readAngles(r, p) == 1) { pick(r, p, f, s); fs[n % N] = f; ss[n % N] = s; n++; }
    delay(20);
    if (n >= N) {
      float rf = fs[n % N], rs = ss[n % N];       // oldest sample = reference
      float lof = 0, hif = 0, los = 0, his = 0, sf = 0, sd = 0;
      for (int i = 0; i < N; i++) {
        float df = wrap180(fs[i] - rf), ds = wrap180(ss[i] - rs);
        if (df < lof) lof = df;
        if (df > hif) hif = df;
        if (ds < los) los = ds;
        if (ds > his) his = ds;
        sf += df; sd += ds;
      }
      bool still = (hif - lof) < 2.0f && (his - los) < 2.0f;
      if (still || millis() - t0 > 8000) { zeroFwd = rf + sf / N; zeroSide = rs + sd / N; break; }
    } else if (millis() - t0 > 8000) break;
  }
  digitalWrite(PIN_LED, LOW);
}

static int8_t shape(float d, bool inv) {              // dead zone + soft curve -> -100..100
  if (inv) d = -d;
  float a = fabsf(d);
  if (a < DEAD_DEG) return 0;
  if (a > FULL_DEG) a = FULL_DEG;
  float v = (a - DEAD_DEG) / (FULL_DEG - DEAD_DEG);
  v = 0.5f * v + 0.5f * v * v;                        // gentle start, full range at the end
  return (int8_t)((d < 0 ? -v : v) * 100.0f);
}

void setup() {
  pinMode(PIN_BTN, INPUT_PULLUP);
  pinMode(PIN_LED, OUTPUT);
#if DEBUG
  Serial.begin(115200);
#endif
  delay(700);                                          // BNO055 boot time
  Wire.begin(21, 22);
  Wire.setClock(I2C_HZ);
  bool ok = bnoInit();
  WiFi.mode(WIFI_AP);
  WiFi.softAP(WIFI_SSID, WIFI_PASS, 1, 0, 1);          // channel 1, visible, one client only (the car)
  WiFi.setSleep(false);
  esp_wifi_set_ps(WIFI_PS_NONE);                       // no radio power-save: lowest latency
  udp.begin(PORT);
  if (!ok) { for (;;) { digitalWrite(PIN_LED, !digitalRead(PIN_LED)); delay(150); } }  // fast blink = IMU not found
  zeroNow();
}

void loop() {
  static uint32_t next = 0;
  static uint8_t fails = 0;
  if (digitalRead(PIN_BTN) == LOW) { delay(30); if (digitalRead(PIN_BTN) == LOW) { zeroNow(); } }
  uint32_t now = millis();
  if ((int32_t)(now - next) < 0) { delay(1); return; }
  next = now + 20;                                     // 50 packets per second

  Pkt k; k.magic = 0xA5; k.thr = 0; k.str = 0;         // stays 0 (stop) if the IMU read fails
  float r, p, f, s;
  int8_t rc = readAngles(r, p);
  if (rc == 1) {
    fails = 0;
    pick(r, p, f, s);
    k.thr = shape(wrap180(f - zeroFwd),  INV_THROTTLE);
    k.str = shape(wrap180(s - zeroSide), INV_STEER);
  } else if (rc == -1 || ++fails >= 25) {              // sensor reset itself, or 0.5 s of I2C errors: re-initialise
    fails = 0;
    bnoInit();                                         // blocks ~1 s; the car stops by itself meanwhile
  }
  k.chk = k.magic ^ (uint8_t)k.thr ^ (uint8_t)k.str;
  bool car = WiFi.softAPgetStationNum() > 0;
  digitalWrite(PIN_LED, car ? HIGH : LOW);
  if (car) {                                           // only transmit when the car is connected
    udp.beginPacket(CAR_IP, PORT);
    udp.write((const uint8_t *)&k, sizeof(k));
    udp.endPacket();
  }
#if DEBUG
  static uint32_t lp = 0;
  if (now - lp > 200) { lp = now; Serial.printf("roll %.1f pitch %.1f -> thr %d str %d\n", r, p, k.thr, k.str); }
#endif
}
