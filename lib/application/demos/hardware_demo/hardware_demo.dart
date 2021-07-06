import 'package:flutter/material.dart';

import '../../src/application_layer.dart';

class HardwareDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HardwareDemoState();
}

class _HardwareDemoState extends State<HardwareDemo> {
  final double _defaultSpacing = 8.0;

  Widget _buildSensorWidget(
    BuildContext context,
    dynamic sensorData,
    SensorMonitor? controller,
  ) {
    return controller != null
        ? Column(
            children: [
              HoverText(
                controller.runtimeType == GyroscopeMonitor
                    ? "Gyroscope"
                    : "Accelerometer",
                bottomPadding: _defaultSpacing,
                topPadding: _defaultSpacing,
              ),
              HoverText(
                  "X:" + (sensorData != null ? sensorData.x.toString() : "")),
              HoverText(
                  "Y:" + (sensorData != null ? sensorData.y.toString() : "")),
              HoverText(
                  "Z:" + (sensorData != null ? sensorData.z.toString() : "")),
              HoverCallToActionButton(
                text: controller.isWatching ? "Stop" : "Start",
                onPressed: controller.toggleMonitoring,
              )
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Application(
      useMaterialAppWidget: true,
      theme: ThemeData.dark(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverHeading("Hardware Demo",
                bottomPadding: _defaultSpacing, topPadding: _defaultSpacing),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HoverText("Camera",
                        bottomPadding: _defaultSpacing,
                        topPadding: _defaultSpacing),
                    CameraControllerWidget(
                      builder: (_, controller, __) => SizedBox(
                        height: 300,
                        child: CameraPreview(controller),
                      ),
                      onSetupBuilder: (_) => CircularProgressIndicator(),
                      onSetupFailedBuilder: (_) => Text("Setup Failed!"),
                    ),
                    GyroscopeWidget(builder: _buildSensorWidget),
                    AccelerometerWidget(builder: _buildSensorWidget),
                    AccelerometerWidget(builder: _buildSensorWidget),
                    AccelerometerWidget(builder: _buildSensorWidget),
                    AccelerometerWidget(builder: _buildSensorWidget),
                    AccelerometerWidget(builder: _buildSensorWidget),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
