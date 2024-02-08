import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dBusDataSourceProvider = Provider<DBusDataSource>((ref) {
  final dBusClient = DBusClient.session();

  return DBusDataSource(
    client: dBusClient,
    remoteObject: DBusRemoteObject(
      dBusClient,
      name: 'de.snapp.ServoControllerService',
      path: DBusObjectPath('/ServoController'),
    ),
  );
});

class DBusDataSource {
  const DBusDataSource({required this.client, required this.remoteObject});

  final DBusClient client;
  final DBusRemoteObject remoteObject;


  Future<DBusMethodSuccessResponse> getAllMotorsState() async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'GetAllMotorsState',
      [],
      replySignature: DBusSignature('a{is}'),
    );

    return response;
  }

  /// returns the state of the specified motor
  /// the [motorId] is the id of the motor to get its state
  Future<DBusMethodSuccessResponse> getMotorState(int motorId) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'GetMotorState',
      [
        DBusInt32(motorId),
      ],
      replySignature: DBusSignature('s'),
    );

    return response;
  }

  /// The motor will be throttled for the specified duration
  /// the [motorId] is the id of the motor to throttle
  /// the [duration] is the duration in seconds
  ///
  /// returns a [bool] indicating if the operation was successful
  Future<DBusMethodSuccessResponse> throttleMotor(
    int motorId,
    int duration,
  ) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'ThrottleMotor',
      [
        DBusInt32(motorId),
        DBusInt32(duration),
      ],
      replySignature: DBusSignature('b'),
    );

    return response;
  }

  /// Start throttling the motor without any specified duration
  /// You will have to call [stopMotor] to stop the motor
  ///
  /// the [motorId] is the id of the motor to throttle
  ///
  /// returns a [bool] indicating if the operation was successful
  Future<DBusMethodSuccessResponse> startThrottle(int motorId) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'StartThrottle',
      [DBusInt32(motorId)],
      replySignature: DBusSignature('b'),
    );

    return response;
  }

  /// Stop throttling the motor
  /// nothing will happen if the motor is not throttling
  ///
  /// the [motorId] is the id of the motor to stop throttling
  ///
  /// returns a [bool] indicating if the operation was successful
  Future<DBusMethodSuccessResponse> stopThrottle(int motorId) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'StopThrottle',
      [DBusInt32(motorId)],
      replySignature: DBusSignature('b'),
    );

    return response;
  }

  /// Close the DBus python session
  Future<DBusMethodSuccessResponse> closeDBusSession() async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'Exit',
      [],
    );

    return response;
  }
}
