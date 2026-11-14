# Project Journal – Gesture Controlled Car

---

## Day 1 – Project Planning (2 Hours)

On the first day, I planned the idea of a gesture-controlled car. The main goal was to control the car by moving my hand. Tilting the hand forward would move the car forward, tilting it backward would move it in reverse, and tilting it sideways would control the steering.

I also planned to use two separate circuits: one transmitter worn on the hand and another receiver fitted inside the car. I decided to use wireless communication between them.

---

## Day 2 – Component Selection and Circuit Diagrams (1 Hour 30 Minutes)

On the second day, I selected the components needed for the project. These included an ESP32, BNO055 motion sensor, TP4056 charging module, boost converter, Arduino Uno R4 WiFi, motor driver and four DC gear motors.

After selecting the components, I prepared separate circuit diagrams for the transmitter and receiver. I also identified the main connections, power supply requirements and function of each component.

---

## Day 3 – Receiver PCB Design (1 Hour 15 Minutes)

On the third day, I worked on the receiver PCB. I converted the receiver circuit diagram into a PCB layout and arranged the components and connectors properly.

I checked the placement of the Arduino Uno headers and motor-related connections. I also created 2D and 3D previews to check the board layout and made the necessary corrections.

---

## Day 4 – Transmitter PCB Design (1 Hour 15 Minutes)

On the fourth day, I designed the transmitter PCB. This board was planned to be worn on the hand and would contain the ESP32 and connections for the motion sensor and power supply modules.

I arranged the connectors and checked the component placement. I also prepared the 2D and 3D views and generated the PCB design files, including Gerber and drill files.

---

## Day 5 – Chassis Design and 3D Modelling (4 Hours)

On the fifth day, I started designing the car chassis. I planned an orange body with rounded corners, space for the receiver PCB and a separate area for the battery.

I selected yellow TT gear motors and designed suitable motor brackets. During the design, I noticed that the motor voltage rating did not match the original battery selection. So I changed the battery arrangement to two 18650 cells in series and planned to limit the motor power.

I also designed the chassis lid and added screw positions with heat-set inserts. After checking the 3D model, I corrected the floor design and made sure the parts were suitable for 3D printing.

---

## Day 6 – Writing and Checking the Code (2 Hours)

On the sixth day, I worked on the Arduino code for both the transmitter and receiver.

The transmitter code reads the hand movements using the BNO055 sensor and sends the movement data wirelessly. The receiver code processes the received data and controls the motors.

I also added a small dead zone to prevent unwanted movement when the hand is in its normal position. I checked the code using a simulator and corrected some issues related to sensor resets, hand calibration and wireless communication.

The code checks passed in the simulator, but the system still needs to be tested with the actual hardware.

---

## Day 7 – README and BOM Preparation (1 Hour 45 Minutes)

On the final day, I prepared the project documentation. I wrote the README file to explain the project, its working principle, components and design files.

I also prepared the Bill of Materials (BOM), including component names, quantities and estimated prices in Indian rupees.

During the final review, I noticed that the selected motor driver was too large for the available chassis space. So I changed the motor driver from Cytron MDD20A to MDD10A and updated the related board information.

Finally, I checked the project files and organized the important files for sharing.

---

