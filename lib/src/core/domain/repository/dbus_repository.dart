import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m_and_m/src/core/data/dbus_data_source.dart';

final dBusRepositoryProvider = Provider<DBusRepository>((ref) {
  return DBusRepository(dataSource: ref.watch(dBusDataSourceProvider));
});

// TODO(payam): complete this class
class DBusRepository {
  const DBusRepository({required this.dataSource});

  final DBusDataSource dataSource;

  Future<Map<int, double>> getMotorsState() async {
    final response = await dataSource.getMotorsState();

    return {};
  }

  Future<bool> turnRedMotor() async {
    final response = await dataSource.turnRedMotor();

    return true;
  }

  Future<bool> turnBlueMotor() async {
    final response = await dataSource.turnBlueMotor();

    return true;
  }

  Future<bool> turnYellowMotor() async {
    final response = await dataSource.turnYellowMotor();

    return true;
  }

  Future<bool> turnGreenMotor() async {
    final response = await dataSource.turnGreenMotor();

    return true;
  }
}
