import 'package:glider_webtop/glider_webtop.dart';

class IotImuData with Created {
  IotImuData({
    required this.timestamp,
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
  });

  final DateTime timestamp;

  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;

  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;

  @override
  DateTime get created => timestamp;
}
