import 'package:flutter/material.dart';

import '../../src/application_layer.dart';

class HardwareDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HardwareDemoState();
}

class _HardwareDemoState extends State<HardwareDemo> {
  late AccelerometerListener accel;

  late GyroscopeListener gyro;

  @override
  void initState() {
    accel = new AccelerometerListener(onSensorEvent: print);
    gyro = new GyroscopeListener(onSensorEvent: print);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Application(
      useMaterialAppWidget: true,
      theme: ThemeData.dark(),
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: CameraControllerWidget(
                builder: (_, controller, __) => CameraPreview(controller),
                onSetupBuilder: (_) => CircularProgressIndicator(),
                onSetupFailedBuilder: (_) => Text("Setup Failed!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
