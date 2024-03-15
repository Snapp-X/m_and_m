# M&M Mixer
The M&M Mixer is an innovative Flutter project designed to run on a Raspberry Pi, transforming the way we enjoy M&M candies. This project elegantly merges the realms of software and hardware to create a unique candy dispensing system. At its core, the M&M Mixer utilizes a Raspberry Pi 5 (or Raspberry Pi 4 Model B), combined with precise mechanical components like the PCA9685 PWM/Servo Driver and SpringRC SM-S4303R Servo Motors, to accurately dispense M&M candies.

Crafted for enthusiasts and developers alike, the M&M Mixer project is not just about mixing candies; it's a comprehensive guide to build a Flutter-based application that interacts seamlessly with custom hardware. From setting up your Raspberry Pi for remote access, wiring servo motors for precise control, to integrating a Python D-Bus server for efficient communication between Flutter and the hardware, this project covers it all. Whether you're looking to delve into the intricacies of hardware-software integration or simply want a smart way to mix your M&Ms, the M&M Mixer offers a fascinating journey into the world of interactive programming and mechanical engineering.

With step-by-step instructions for hardware assembly, software development, and a detailed exploration of connecting Flutter to hardware, the M&M Mixer is your gateway to create a customizable, tech-driven candy experience. Join us as we explore the potential of Flutter and Raspberry Pi to bring a playful, innovative twist to candy dispensing.


## Hardware

The foundation of the M&M Mixer is its hardware, a meticulously designed setup that combines computational power with mechanical precision to dispense M&M candies. The construction process involves several key components:

- **Raspberry Pi 5 :**
  The Raspberry Pi 5 (4Gb/8Gb) was chosen for its robust processing capabilities and affordability, making it the heart of our project. It controls the intricacies of the M&M Mixer, managing the flow of data and commands that orchestrate the candy dispensing process. A Raspberry Pi Model 4 B will work just fine as well.

- **[PCA9685 - Adafruit 16-Channel 12-bit PWM/Servo Driver](https://www.adafruit.com/product/815 "PCA9685 - Adafruit 16-Channel 12-bit PWM/Servo Driver"):**
  A vital link between the Raspberry Pi and the servo motors, the PCA9685 PWM/Servo Driver, allowes us to achieve precise control over the servo movements. This precision is crucial for the accurate dispensing of M&M candies into their designated dispensers. [More about PCA9685](https://www.adafruit.com/product/815).

- **[SpringRC SM-S4303R Servo Motors:](https://www.pololu.com/product/1248 "SpringRC SM-S4303R Servo Motors:")**
  We incorporated four SM-S4303R servo motors into our design, assigning each motor to handle a specific color of M&M candy. These high-torque motors were selected for their reliability and the precise control they offer, enabling us to manipulate the M&M dispensers with exceptional accuracy.

- **[M&M Dispensers](https://www.amazon.de/gp/product/B0995R4P1P/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&th=1 "M&M Dispensers"):**
  The design includes four custom M&M dispensers, each tailored to separate a different color variant of M&M candies. These dispensers are integral to the Mixer's operation, ensuring a seamless mix of colors as per user preferences.

## Assembly Steps:

The assembly of the M&M Mixer involves a series of steps designed to ensure both functionality and reliability:

1. **Remote Raspberry Pi Setup:**
   Initially, we utilized `snapp_cli` for a remote setup of the Raspberry Pi. This tool streamlined the process, allowing for the installation of necessary software and enabling remote access with minimal effort. Check out [snapp_cli GitHub repository](https://github.com/Snapp-Embedded/snapp_cli) for installation instructions.

2. **Manual Raspberry Pi Preparation:**
   If you have already completed the remote setup using snapp_cli, you can skip this step. For hands-on enthusiasts who prefer or need a manual setup, we provide detailed instructions. This approach involves connecting peripheral devices directly to the Raspberry Pi and employing `snapp_installer` for an effortless Flutter installation. Install Flutter using `snapp_installer` with this single command:

   ```bash
   bash <(curl -fSL https://snappembedded.io/installer) && source ~/.bashrc
   ```

3. **Repository Cloning:**
   The next step is to clone the M&M Mixer's repository onto the Raspberry Pi. This repository contains all the code and resources needed to bring the Mixer to life. Clone with the following command:
   ```bash
   git clone https://github.com/Snapp-Embedded/m_and_m.git
	```

4. **I2C Interface Activation:**
   To communicate with the PCA9685 driver, we need to enbale the I2C interface on the Raspberry Pi.

5. **Motor Wiring:**
   You can follow a detailed video to connect the Raspberry Pi to the PCA9685 board and the servo motors. Proper wiring is essential. A helpful video guide can be found here: [Raspberry Pi and PCA9685](https://youtu.be/9jcEwn7GzNs?si=1oX7w1uAstdxEzZp)

6. **Python Dbus Server Launch:**
   Finally, we initiate the Python Dbus server. This server plays a pivotal role in managing the communication between the Raspberry Pi and the hardware components, ensuring that the M&M Mixer performs flawlessly. Start the server with:
   ```bash
   bash server_runner.sh
	```


## Connecting Flutter to Hardware

Integrating Flutter with hardware components in a project like the M&M Mixer presents multiple pathways. Options range from setting up an MQTT broker or a REST API to delving into the hardware's datasheet and crafting a complete Dart plugin specifically tailored for it. Each approach offers its unique advantages, catering to different project requirements and complexity levels.

Our decision to enable communication between the Flutter application and the Raspberry Pi's hardware was driven by a desire for efficiency and practicality in the M&M Mixer project. The PCA9685 servo driver, is supported by an excellent Python library that simplifies controlling the servo motors. To leverage this library, we decided to establish a Python D-Bus server. This approach allows us to utilize the existing Python library without the need to directly implement low-level control in Dart, streamlining the development process.

#### Why D-Bus?

D-Bus offers a robust inter-process communication (IPC) mechanism, enabling separate processes to communicate with each other seamlessly. By creating a Python D-Bus server, we effectively expose the functionality of the PCA9685's Python library over D-Bus, making it accessible to other applications running on the same machine.

## Software

We developed the M&M Mixer's software entirely using Flutter, making it easy to run and manage. To quickly get the project up and running it, simply clone the repository and use `pub get` to fetch the necessary packages. Running the project is straightforward after these steps.

Ensure you start the Python server beforehand. The server is crucial for handling the interactions and operations of the M&M Mixer.

Here are the steps to get your software running:

1. **Clone the Repository (if not already done):**
	``` bash
   git clone https://github.com/Snapp-Embedded/m_and_m.git
	```
2. **Fetch the Dependencies:**
Navigate to the project directory and run:
	``` bash
   flutter pub get
	```
1. **Run the Python Server:**
Before launching the Flutter app, ensure the Python server is running to manage the hardware interactions:
	``` bash
   bash server_runner.sh
	```
1. **Run the Flutter Application:**
Finally, execute your Flutter application:
	``` bash
   flutter run
	```