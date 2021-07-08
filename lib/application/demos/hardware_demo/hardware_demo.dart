import 'package:flutter/material.dart';
import 'package:glider/data/webtop_data_layer.dart';

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

  Widget _buildCameraControllerWidget() {
    return CameraControllerWidget(
      builder: (context, snapshot) {
        switch (snapshot.status) {
          case CameraControllerWidgetStatus.loading:
            return CircularProgressIndicator();

          case CameraControllerWidgetStatus.initialized:
            final controller = snapshot.controller;
            return SizedBox(
              height: 300,
              child:
                  controller != null ? CameraPreview(controller) : Container(),
            );

          case CameraControllerWidgetStatus.setupFailed:
            return Text("Setup Failed!");

          default:
            return SizedBox.shrink();
        }
      },
    );
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
            // _buildCameraControllerWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HoverText(
                      "Camera",
                      bottomPadding: _defaultSpacing,
                      topPadding: _defaultSpacing,
                    ),
                    AccelerometerWidget(builder: _buildSensorWidget),
                    GyroscopeWidget(builder: _buildSensorWidget),
                    HoverText(
                      "WebSocket",
                      bottomPadding: _defaultSpacing,
                      topPadding: _defaultSpacing,
                    ),
                    WebSocketWidget(
                        webSocket: WebtopClient(
                          host: "192.168.100.191",
                          port: 6767,
                          socketPort: 6868,
                        ),
                        builder: (context, snapshot) {
                          switch (snapshot.status) {
                            case WebSocketWidgetStatus.messageReceived:
                              snapshot.message?.debug();
                              return Text(
                                snapshot.message?.data ?? "",
                              );
                            default:
                          }

                          return Container();
                        })
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
