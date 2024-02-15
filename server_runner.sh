#!/bin/bash

# Step 1: Update and Upgrade
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y
echo

echo "Check Python 3 Installation..."
echo
if command -v python3 &>/dev/null; then
    echo "Python 3 is installed."
else
    echo "Python 3 is not installed. Installing Python 3..."
    sudo apt install python3 -y
fi

echo "Check and Install Required Pip Packages"
echo
REQUIRED_PKG=("adafruit-circuitpython-pca9685" "adafruit-circuitpython-servokit")
echo "Checking and installing required pip packages..."
for pkg in "${REQUIRED_PKG[@]}"; do
    if pip3 show "$pkg" &>/dev/null; then
        echo "$pkg is already installed."
    else
        echo "$pkg is not installed. Installing $pkg..."
        sudo pip3 install "$pkg"
    fi
done

echo
echo "Enable I2C Interface on Raspberry Pi..."
echo

# sudo raspi-config nonint get_i2c this command will return 0 or 1 based on the status of I2C interface
if [ "$(sudo raspi-config nonint get_i2c)" -eq 0 ]; then
    echo "I2C interface is already enabled."
else
    echo "I2C interface is not enabled. Enabling I2C interface..."
    sudo raspi-config nonint do_i2c 0
fi

echo
echo "Everything is set up. Running the Python server script..."
echo

python3 ./python_server/servo_controller.py
