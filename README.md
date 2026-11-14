# Gesture Controlled Car

A car that can be controlled using hand movements. By tilting my wrist, I can control the direction and speed of the car without using a traditional remote controller.

The project uses a motion sensor mounted on a hand-worn transmitter. The transmitter sends the movement data wirelessly to the car, where a microcontroller controls the motors.

---

## How It Works

The project has two main parts:

### 1. Transmitter (Hand Unit)

The transmitter consists of an ESP32 and a BNO055 motion sensor. The sensor detects the tilt of the hand and the ESP32 processes the movement data. It then sends the commands to the car through Wi-Fi.

### 2. Receiver (Car Unit)

The receiver uses an Arduino UNO R4 WiFi and a motor driver. It receives the commands from the transmitter and controls the four DC motors according to the hand movement.

---

## Hand Movement Controls

| Hand Movement | Car Action |
|---|---|
| Tilt wrist forward | Move forward |
| Tilt wrist backward | Move backward |
| Tilt wrist right | Turn right |
| Tilt wrist left | Turn left |
| Keep hand level | Stop |

---

## Main Components

### Transmitter

- ESP32 DevKitC-32E
- BNO055 motion sensor
- 3.7V 2000mAh Li-Po battery
- TP4056 USB-C charging module
- 5V boost converter
- Slide switch
- 100µF capacitor

### Receiver

- Arduino UNO R4 WiFi
- Cytron MDD10A motor driver
- 4 yellow TT gear motors
- 4 wheels (65mm)
- 2 × 18650 batteries
- 2S battery protection board
- 10A fuse
- XT60 connector
- Power switch

---

## Communication

The transmitter creates its own Wi-Fi network named **"GestureCar"**. The car connects to this network and receives movement information through UDP communication.

The transmitter sends data at 50 packets per second. The receiver uses the received throttle and steering values to control the left and right motors.

The system also includes a safety feature that stops the motors when communication is interrupted.

---

## PCB Design

Two separate PCBs are designed for the project.

| Feature | Transmitter PCB | Receiver PCB |
|---|---|---|
| Size | 92 × 64 mm | 116 × 64 mm |
| Layers | 2 | 2 |
| Thickness | 1.6 mm | 1.6 mm |
| Main controller | ESP32 | Arduino UNO R4 WiFi |

The transmitter PCB contains the connections for the ESP32, motion sensor and power supply modules.

The receiver PCB provides the connections for the Arduino, motor driver signals and battery supply.

Both PCB designs include mounting holes and connectors for easier assembly.

---

## 3D Chassis Design

The car body is designed as a separate base and lid. The design also includes four motor brackets.

The main parts are:

- Car body base
- Top lid
- Two types of motor brackets
- Mounting positions for the receiver PCB
- Space for the battery and motor driver

The chassis is designed for orange PETG 3D printing. The motor brackets hold the four TT gear motors in position.

### 3D Model Files

| File | Description |
|---|---|
| `car_body_base.stl` | Main chassis |
| `car_lid.stl` | Top cover |
| `motor_bracket_A.stl` | Motor mounting bracket |
| `motor_bracket_B.stl` | Mirrored motor mounting bracket |

---

## Software

The project uses Arduino IDE to program both controllers.

### Transmitter code: `gesture_transmitter.ino`

- Reads the BNO055 sensor.
- Detects hand tilt.
- Calculates throttle and steering values.
- Sends data wirelessly through UDP.

### Receiver code: `gesture_receiver.ino`

- Receives data from the transmitter.
- Processes movement commands.
- Controls the motor driver.
- Adjusts motor speed and direction.
- Stops the motors when the wireless connection is lost.

Both programs include adjustable settings for sensor direction, motor direction, speed and movement sensitivity.

---

## Project Files

```text
Gesture_Controlled_Car/
│
├── README.md
├── JOURNAL.md
├── BOM.md
├── LICENSE
│
├── gesture_transmitter.ino
├── gesture_receiver.ino
│
├── gesture_tx_gerbers.zip
├── gesture_rx_gerbers.zip
│
├── car_body_base.stl
├── car_lid.stl
├── motor_bracket_A.stl
└── motor_bracket_B.stl
```

---

## Power Supply

The transmitter uses a 3.7V Li-Po battery with a charging module and a 5V boost converter.

The car uses two 18650 cells connected in series with a suitable battery protection board. The motor power is controlled through the Cytron MDD10A driver.

The motor speed is limited in the program to suit the selected motors.

---

## Safety Notes

- Use a suitable battery protection circuit.
- Check the polarity before connecting the power supply.
- Use the correct charger for the battery configuration.
- Keep the motor wheels clear of the ground when checking motor operation.
- Avoid short circuits in the battery connections.

---

## Bill of Materials

The complete component list, quantities and estimated prices are available in [BOM.md](BOM.md).

---

## Project Journal

The development process, including planning, component selection, circuit diagrams, PCB design, chassis modelling, programming and documentation, is recorded in [JOURNAL.md](JOURNAL.md).

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
