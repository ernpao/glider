abstract class IotInterface {
  /// Send accelerometer and gyroscope readings to the Webtop server.
  void sendImuData(
    String sender, {
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    double? gyroscopeX,
    double? gyroscopeY,
    double? gyroscopeZ,
  });
}
