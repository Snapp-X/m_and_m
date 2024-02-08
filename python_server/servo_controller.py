#!/usr/bin/env python3

from __future__ import print_function
from datetime import datetime, timezone
from gi.repository import GLib
from board import SCL, SDA

import dbus
import dbus.service
import dbus.mainloop.glib
import time
import busio

from adafruit_motor import servo
from adafruit_servokit import ServoKit
from adafruit_pca9685 import PCA9685

usage = """
Snapp ServoControllerService Started Successfully

Wait for the client to connect:
"""


class ServoController(dbus.service.Object):
    """ Python class to control the servo motors using PCA9685"""
    def __init__(self, bus, path):
        super(ServoController, self).__init__(bus, path)
        # Initialize I2C and PCA9685
        self.i2c = busio.I2C(SCL, SDA)
        self.pca = PCA9685(self.i2c)
        self.pca.frequency = 50
        
        # number of servos connected to the PCA9685
        self.servos_count = 4 

        # Initialize servo objects
        self.servos = [servo.ContinuousServo(self.pca.channels[i]) for i in range(self.servos_count)]


    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='', out_signature='a{is}')
    def GetAllMotorsState(self):
        print("GetAllMotorsState request:", session_bus.get_unique_name())
        
        # Use the pre-initialized servo objects
        servo_states = {i: str(self.servos[i].throttle) for i in range(self.servos_count)}
        return servo_states    

    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='s')
    def GetMotorState(self, motor_id):
        print("GetMotorState request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        # Check if motor_id is valid
        if 0 <= motor_id < len(self.servos):
            return str(self.servos[motor_id].throttle)
        else:
            return "Invalid motor ID"
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='ii', out_signature='b')
    def ThrottleMotor(self, motor_id, duration):
        print("ThrottleMotor request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        print("Duration:", duration)
        if 0 <= motor_id < len(self.servos):
            self.servos[motor_id].throttle = 1
            time.sleep(duration)
            self.servos[motor_id].throttle = 0.0
            time.sleep(0.1)
            return True
        else:
            return False 
        
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='b')
    def StartThrottle(self, motor_id):
        print("StartThrottle request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        if 0 <= motor_id < len(self.servos):
            time.sleep(0.03)
            self.servos[motor_id].throttle = 1
            time.sleep(0.03)
            return True
        else:
            return False
        
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='b')
    def StopThrottle(self, motor_id):
        print("StopThrottle request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        if 0 <= motor_id < len(self.servos):
            time.sleep(0.03)
            self.servos[motor_id].throttle = 0.0
            time.sleep(0.03)
            return True
        else:
            return False
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='', out_signature='')
    def Exit(self):
        self.pca.deinit()
        mainloop.quit()

if __name__ == '__main__':
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    session_bus = dbus.SessionBus()
    name = dbus.service.BusName("de.snapp.ServoControllerService", session_bus)
    controller = ServoController(session_bus, '/ServoController')
    
    # Run the main loop
    mainloop = GLib.MainLoop()
    print(usage)

    mainloop.run()
    
    