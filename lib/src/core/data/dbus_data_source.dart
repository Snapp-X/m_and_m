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

  Future<DBusMethodSuccessResponse> getMotorsState() async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'CurrentMotorStates',
      [],
      replySignature: DBusSignature('is'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> getMotorState(int motorId) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'CurrentMotorState',
      [
        DBusInt32(motorId),
      ],
      replySignature: DBusSignature('s'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> turnMotorInDegree(int motorId) async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'TurnMotorInDegree',
      [DBusInt32(motorId)],
      replySignature: DBusSignature('b'),
    );

    return response;
  }

  Future<DBusMethodSuccessResponse> testServer() async {
    final response = await remoteObject.callMethod(
      'de.snapp.ServoControllerInterface',
      'HelloWorld',
      [],
      replySignature: DBusSignature('s'),
    );

    return response;
  }
}
