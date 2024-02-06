import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/data/dbus_data_source.dart';

final dBusRepositoryProvider = Provider<DBusRepository>((ref) {
  return DBusRepository(dataSource: ref.watch(dBusDataSourceProvider));
});

// TODO(payam): complete this class
class DBusRepository {
  const DBusRepository({required this.dataSource});

  final DBusDataSource dataSource;

  Future<bool> testServer() async {
    final response = await dataSource.testServer();

    log('DBusRepository.testServer: $response');

    return true;
  }

  Future<Map<int, String>> getMotorsState() async {
    final response = await dataSource.getMotorsState();

    final returnValue = response.returnValues[0];

    final parsedResult = returnValue.toNative();

    if (parsedResult is! Map) {
      throw Exception('Invalid response');
    }
    
    return parsedResult.map(
      (key, value) => MapEntry(key, value),
    );
  }

  Future<bool> turnRedMotor() async {
    return true;
  }

  Future<bool> turnBlueMotor() async {
    return true;
  }

  Future<bool> turnYellowMotor() async {
    return true;
  }

  Future<bool> turnGreenMotor() async {
    return true;
  }
}
