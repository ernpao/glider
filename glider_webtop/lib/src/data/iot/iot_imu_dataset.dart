import 'package:glider_webtop/glider_webtop.dart';

import 'iot_imu_data.dart';

class IotImuDataset with Created {
  IotImuDataset({
    required this.id,
    required this.data,
    required this.created,
  });

  final String id;

  @override
  DateTime created;

  final List<IotImuData> data;
}
