import 'package:glider/glider.dart';
import 'iot_interface.dart';

class IotWebAPI extends WsAPI implements IotInterface {
  IotWebAPI({
    required String host,
    required int socketPort,
  }) : super(
          host: host,
          useHttps: false,
          useWss: false,
          webSocketPort: socketPort,
        );

  @override
  void sendImuData(
    String sender, {
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
  }) {
    final accelDataJson = JSON()
      ..setProperty("x", accelerometerX)
      ..setProperty("y", accelerometerY)
      ..setProperty("z", accelerometerZ);
    final gyroDataJson = JSON()
      ..setProperty("x", gyroscopeX)
      ..setProperty("y", gyroscopeY)
      ..setProperty("z", gyroscopeZ);

    final sensorDataJson = JSON()
      ..setProperty("accelerometer", accelDataJson)
      ..setProperty("gyroscope", gyroDataJson);
    socket.sendWsData(
      WsData(
        sender: sender,
        body: sensorDataJson.stringify(),
        type: "iot",
        category: "sensor",
      ),
    );
  }
}
