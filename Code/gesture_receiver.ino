
#include <WiFiS3.h>

// ---------------- settings ----------------
static const char     WIFI_SSID[] = "GestureCar";
static const char     WIFI_PASS[] = "car12345pass"; // identical on the transmitter
static const uint16_t PORT        = 4210;
static const uint8_t  PWM_L = 5, DIR_L = 4, PWM_R = 6, DIR_R = 7;
static const bool     INV_L = false, INV_R = false; // flip if that side runs backwards
static const uint8_t  MAX_DUTY_PCT = 70;            // yellow TT motors are 3-6 V: 70% of 7-8.4 V is about 5-6 V
static const uint8_t  ACCEL_STEP   = 3;             // % per 10 ms while speeding up (0 to full in ~0.33 s)
static const uint8_t  BRAKE_STEP   = 8;             // % per 10 ms while slowing down
static const uint16_t LINK_TIMEOUT_MS = 250;        // no packet for this long = stop and disarm
#define DEBUG 0

static const uint8_t MAX_DUTY = (uint8_t)(255UL * MAX_DUTY_PCT / 100);
static WiFiUDP udp;
static uint32_t lastRx = 0, lastTick = 0, lastPoll = 0, lastStat = 0, lastTry = 0;
static int8_t  rxThr = 0, rxStr = 0;
static bool    armed = false, udpUp = false, linked = false, firstTry = true;
static int     curL = 0, curR = 0;
static int     outDirL = -1, outDirR = -1, outPwmL = -1, outPwmR = -1;

static void drive(uint8_t pwmPin, uint8_t dirPin, bool inv, int v, int &lastDir, int &lastPwm) {
  int dir = ((v >= 0) != inv) ? HIGH : LOW;
  int duty = (abs(v) * MAX_DUTY) / 100;
  if (dir != lastDir) { digitalWrite(dirPin, dir); lastDir = dir; }
  if (duty != lastPwm) { analogWrite(pwmPin, duty); lastPwm = duty; }
}
static void stopMotors() {
  curL = curR = 0;
  analogWrite(PWM_L, 0); analogWrite(PWM_R, 0);
  outPwmL = outPwmR = 0;
}
static inline int ramp(int cur, int target) {
  int lim = (abs(target) > abs(cur)) ? ACCEL_STEP : BRAKE_STEP;
  return cur + constrain(target - cur, -lim, lim);
}
static void connectWifi() {
  stopMotors();
  armed = false;
  if (udpUp) { udp.stop(); udpUp = false; }
  WiFi.config(IPAddress(192, 168, 4, 50), IPAddress(192, 168, 4, 1), IPAddress(192, 168, 4, 1), IPAddress(255, 255, 255, 0));
  WiFi.begin(WIFI_SSID, WIFI_PASS);                    // blocks a few seconds; motors are already stopped
  linked = (WiFi.status() == WL_CONNECTED);
  if (linked) { udp.begin(PORT); udpUp = true; }
  lastTry = lastStat = millis(); firstTry = false;
}

void setup() {
  pinMode(PWM_L, OUTPUT); pinMode(DIR_L, OUTPUT);
  pinMode(PWM_R, OUTPUT); pinMode(DIR_R, OUTPUT);
  stopMotors();
#if DEBUG
  Serial.begin(115200);
#endif
}

void loop() {
  uint32_t now = millis();

  if (now - lastStat >= 1000) {                        // connection check once a second
    lastStat = now;
    linked = (WiFi.status() == WL_CONNECTED);
  }
  if (!linked || !udpUp) {                             // not linked: motors off, retry every 2 s
    stopMotors();
    armed = false;
    if (firstTry || now - lastTry > 2000) connectWifi();
    return;
  }

  if (now - lastPoll >= 5) {                           // network poll at 200 Hz
    lastPoll = now;
    while (udp.parsePacket() > 0) {                    // read every waiting packet, keep the newest
      uint8_t b[16];
      int n = udp.read(b, sizeof(b));
      if (n == 4 && b[0] == 0xA5 && (uint8_t)(b[0] ^ b[1] ^ b[2]) == b[3]) {
        rxThr = (int8_t)b[1]; rxStr = (int8_t)b[2]; lastRx = now;
        if (!armed && abs(rxThr) <= 8 && abs(rxStr) <= 8) armed = true;   // must see a neutral hand first
      }
    }
  }

  if (now - lastTick < 10) return;                     // control loop at 100 Hz
  lastTick = now;

  bool alive = (now - lastRx) < LINK_TIMEOUT_MS;
  if (!alive) armed = false;                           // lost link: stop and wait for a neutral hand again

  int thr = (armed && alive) ? rxThr : 0;
  int str = (armed && alive) ? rxStr : 0;
  int l = thr + str, r = thr - str;                    // skid-steer mix
  int m = max(abs(l), abs(r));
  if (m > 100) { l = l * 100 / m; r = r * 100 / m; }   // keep the ratio, limit to full scale

  curL = ramp(curL, l);
  curR = ramp(curR, r);
  drive(PWM_L, DIR_L, INV_L, curL, outDirL, outPwmL);
  drive(PWM_R, DIR_R, INV_R, curR, outDirR, outPwmR);
#if DEBUG
  static uint32_t lp = 0;
  if (now - lp > 200) { lp = now; Serial.print(curL); Serial.print(' '); Serial.println(curR); }
#endif
}
