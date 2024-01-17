import 'package:dbus/dbus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dBusDataSourceProvider = Provider<DBusDataSource>((ref) {
  var dBusClient = DBusClient.session();
  return DBusDataSource(
    client: dBusClient,
    remoteObject: DBusRemoteObject(
      dBusClient,
      name: 'de.snapp.MotorService',
      path: DBusObjectPath('/Motor'),
    ),
  );
});

class DBusDataSource {
  const DBusDataSource({required this.client, required this.remoteObject});

  final DBusClient client;
  final DBusRemoteObject remoteObject;

  Future<DBusMethodSuccessResponse> getMotorsState() async {
    final response = await remoteObject.callMethod(
      'de.snapp.InterfaceName',
      'getMotorsState',
      [],
      replySignature: DBusSignature('as'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> turnRedMotor() async {
    final response = await remoteObject.callMethod(
      'de.snapp.InterfaceName',
      'turnRedMotor',
      [],
      replySignature: DBusSignature('as'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> turnBlueMotor() async {
    final response = await remoteObject.callMethod(
      'de.snapp.InterfaceName',
      'turnBlueMotor',
      [],
      replySignature: DBusSignature('as'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> turnYellowMotor() async {
    final response = await remoteObject.callMethod(
      'de.snapp.InterfaceName',
      'turnYellowMotor',
      [],
      replySignature: DBusSignature('as'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> turnGreenMotor() async {
    final response = await remoteObject.callMethod(
      'de.snapp.InterfaceName',
      'turnGreenMotor',
      [],
      replySignature: DBusSignature('as'),
    );

    return response;
  }
}
