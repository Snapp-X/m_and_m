# m_and_m

## Connecting Flutter to Hardware

Integrating Flutter with hardware components in a project like the M&M Mixer presents multiple pathways. Options range from setting up an MQTT broker or a REST API to delving into the hardware's datasheet and crafting a complete Dart plugin specifically tailored for it. Each approach offers its unique advantages, catering to different project requirements and complexity levels.

For the M&M Mixer, our choice to facilitate communication between the Flutter application and the Raspberry Pi's hardware modules was driven by a desire for efficiency and practicality. The PCA9685 servo driver, a critical component of our hardware setup, is supported by an excellent Python library that simplifies controlling the servo motors. To leverage this library, we decided to establish a Python D-Bus server. This approach allows us to utilize the existing Python library without the need to directly implement low-level control in Dart, streamlining the development process.

### Why D-Bus?

D-Bus offers a robust inter-process communication (IPC) mechanism, enabling separate processes to communicate with each other seamlessly. By creating a Python D-Bus server, we effectively expose the functionality of the PCA9685's Python library over D-Bus, making it accessible to other applications running on the same machine.

## Hardware

The foundation of the M&M Mixer is its hardware, a meticulously designed setup that combines computational power with mechanical precision to dispense M&M candies. The construction process involved several key components:

- **Raspberry Pi 4 Model B:**
  The Raspberry Pi 4 Model B was chosen for its robust processing capabilities and affordability, making it the heart of our project. It controls the intricacies of the M&M Mixer, managing the flow of data and commands that orchestrate the candy dispensing process.

- **PCA9685 - Adafruit 16-Channel 12-bit PWM/Servo Driver:**
  A vital link between the Raspberry Pi and the servo motors, the PCA9685 PWM/Servo Driver, allowed us to achieve precise control over the servo movements. This precision is crucial for the accurate dispensing of M&M candies into their designated dispensers. [More about PCA9685](https://www.adafruit.com/product/815).

- **MG996R Servo Motors:**
  We incorporated four MG996R servo motors into our design, assigning each motor to handle a specific color of M&M candy. These high-torque motors were selected for their reliability and the precise control they offer, enabling us to manipulate the M&M dispensers with exceptional accuracy.

- **M&M Dispensers:**
  The design included four custom M&M dispensers, each tailored to separate a different color variant of M&M candies. These dispensers are integral to the Mixer's operation, ensuring a seamless mix of colors as per user preferences.

## Constructive Steps:

The assembly of the M&M Mixer involved a series of steps designed to ensure both functionality and reliability:

1. **Remote Raspberry Pi Setup:**
   Initially, we utilized `snapp_cli` for a remote setup of the Raspberry Pi. This tool streamlined the process, allowing for the installation of necessary software and enabling remote access with minimal effort. Check out [snapp_cli GitHub repository](https://github.com/Snapp-Embedded/snapp_cli) for installation instructions.

2. **Manual Raspberry Pi Preparation:**
   For hands-on enthusiasts, we also provided instructions for a manual setup. This approach included connecting peripheral devices directly to the Raspberry Pi and employing `snapp_installer` for an effortless Flutter installation. Install Flutter using `snapp_installer` with this single command:
	```bash
   curl -sSL https://raw.githubusercontent.com/Snapp-Embedded/snapp_installer/main/install.sh | bash
	```

3. **Repository Cloning:**
   The next step involved cloning the M&M Mixer's repository onto the Raspberry Pi. This repository contained all the code and resources needed to bring the Mixer to life. Clone with the following command:
   ```bash
   git clone https://github.com/Snapp-Embedded/m_and_m.git
	```

4. **I2C Interface Activation:**
   To communicate with the PCA9685 driver, we enabled the I2C interface on the Raspberry Pi. This step was crucial for the seamless operation of the servo motors.

5. **Motor Wiring:**
   We followed detailed guides and videos to connect the Raspberry Pi to the PCA9685 board and the servo motors. Proper wiring was essential for the accurate performance of the dispensers. A helpful video guide can be found here: [Raspberry Pi and PCA9685](https://www.youtube.com/watch?v=3vQyI2b4e6Y)

6. **Python Dbus Server Launch:**
   Finally, we initiated the Python Dbus server. This server played a pivotal role in managing the communication between the Raspberry Pi and the hardware components, ensuring that the M&M Mixer performed flawlessly. Start the server with:
   ```bash
   bash server_runner.sh
	```


With the hardware setup complete and the Raspberry Pi ready, including Flutter installed, our M&M Mixer's foundation is solid. Now, it's time to shift our focus to software development, where we'll bring the Mixer to life through programming


## Software

We developed the M&M Mixer's software entirely using Flutter, making it easy to run and manage. To quickly get the project up and running it, simply clone the repository and use `pub get` to fetch the necessary packages. Running the project is straightforward after these steps.

Ensure you start the Python server beforehand to facilitate smooth communication between the software and the hardware components. This server is crucial for handling the interactions and operations of the M&M Mixer.

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