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

    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='', out_signature='a{is}')
    def CurrentMotorStates(self):
        print("CurrentMotorStates request:", session_bus.get_unique_name())
        servo0 = servo.Servo(pca.channels[0])
        servo1 = servo.Servo(pca.channels[1])
        servo2 = servo.Servo(pca.channels[2])
        servo3 = servo.Servo(pca.channels[3])
        
        return {0: str(servo0.angle), 1: str(servo1.angle), 2: str(servo2.angle), 3: str(servo3.angle)}
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='d')
    def CurrentMotorState(self, motor_id):
        print("CurrentMotorState request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        
        servo_motor = servo.Servo(pca.channels[motor_id])
        
        return str(servo_motor.angle)
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='b')
    def TurnMotorInDegree(self, motor_id):
        print("TurnMotorInDegree request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
        
        servo_motor = servo.Servo(pca.channels[motor_id])
        
        current_angle = servo_motor.angle
        
        if current_angle <= 0:
            servo_motor.angle = 180
        else:
            servo_motor.angle = 0
            
        return True
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='', out_signature='')
    def Exit(self):
        mainloop.quit()


if __name__ == '__main__':
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    session_bus = dbus.SessionBus()
    name = dbus.service.BusName("de.snapp.ServoControllerService", session_bus)
    object = ServoController(session_bus, '/ServoController')

    mainloop = GLib.MainLoop()
    print(usage)
    
    i2c = busio.I2C(SCL, SDA)

    pca = PCA9685(i2c)

    pca.frequency = 50

    mainloop.run()