#!/usr/bin/env python3

from __future__ import print_function
from datetime import datetime, timezone
from gi.repository import GLib

import dbus
import dbus.service
import dbus.mainloop.glib

usage = """
Snapp ServoControllerService Started Successfully

Wait for the client to connect:
"""

class ServoController(dbus.service.Object):

    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='', out_signature='a{is}')
    def CurrentMotorStates(self):
        print("CurrentMotorStates request:", session_bus.get_unique_name())
        return {0: "30d", 1: "180d"}
    
    
    @dbus.service.method("de.snapp.ServoControllerInterface",
                         in_signature='i', out_signature='b')
    def TurnMotorInDegree(self, motor_id):
        print("TurnMotorInDegree request:", session_bus.get_unique_name())
        print("Motor ID:", motor_id)
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
    mainloop.run()