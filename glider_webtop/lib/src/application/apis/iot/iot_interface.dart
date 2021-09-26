import 'package:glider/glider.dart';

abstract class IotInterface {
  /// Send accelerometer and gyroscope readings to the Webtop server.
  void sendImuData(
    String sender,
    JSON dataSetInfo, {
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
  });

  Future<List<String>> getWsDataSenders();
}
