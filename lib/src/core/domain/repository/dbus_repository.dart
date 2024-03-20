import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/data/dbus_data_source.dart';

final dBusRepositoryProvider = Provider<DBusRepository>((ref) {
  return DBusRepository(dataSource: ref.watch(dBusDataSourceProvider));
});

class DBusRepository {
  const DBusRepository({required this.dataSource});

  final DBusDataSource dataSource;

  /// Get the state of all motors
  /// returns a [Map] of motor id and its state
  Future<Map<int, String>> getAllMotorsState() async {
    final response = await dataSource.getAllMotorsState();

    final returnValue = response.returnValues[0];

    final parsedResult = returnValue.toNative();

    if (parsedResult is! Map) {
      throw Exception('Invalid response type');
    }

    return parsedResult.map(
      (key, value) => MapEntry(key, value),
    );
  }

  /// returns the state of the specified motor
  /// the [motorId] is the id of the motor to get its state
  Future<String> getMotorState(int motorId) async {
    final response = await dataSource.getMotorState(motorId);

    final returnValue = response.returnValues[0];

    final parsedResult = returnValue.toNative();

    if (parsedResult is! String) {
      throw Exception('Invalid response type');
    }

    return parsedResult;
  }

  /// The motor will be throttled for the specified duration
  /// the [motorId] is the id of the motor to throttle
  /// the [duration] is the duration in seconds
  ///
  /// returns a [bool] indicating if the operation was successful
  Future<bool> throttleMotor(int motorId,
      {double duration = 0.5, double speed = 0.5}) async {
    final response = await dataSource.throttleMotor(motorId, duration, speed);

    final returnValue = response.returnValues[0];

    final parsedResult = returnValue.toNative();

    if (parsedResult is! bool) {
      throw Exception('Invalid response type');
    }

    return parsedResult;
  }

  /// Stop throttling the motor
  /// nothing will happen if the motor is not throttling
  ///
  /// the [motorId] is the id of the motor to stop throttling
  ///
  /// returns a [bool] indicating if the operation was successful
  Future<bool> stopMotor(int motorId) async {
    final response = await dataSource.startThrottle(motorId);

    final returnValue = response.returnValues[0];

    final parsedResult = returnValue.toNative();

    if (parsedResult is! bool) {
      throw Exception('Invalid response type');
    }

    return parsedResult;
  }
}
