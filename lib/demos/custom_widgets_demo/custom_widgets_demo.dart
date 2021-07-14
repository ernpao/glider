import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hover/hover.dart';

import '../../glider.dart';

class CustomWidgetsDemo extends StatelessWidget {
  final bool demoCamera;
  final bool demoSensors;
  final bool demoWebWidgets;

  CustomWidgetsDemo({
    this.demoCamera = true,
    this.demoWebWidgets = true,
    this.demoSensors = true,
  });

  @override
  Widget build(BuildContext context) {
    return Application(
      useMaterialAppWidget: true,
      theme: ThemeData.dark(),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverHeading(
              "Custom Widgets Demo",
              bottomPadding: 8.0,
              topPadding: 8.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (demoCamera) _CameraDemo(),
                    if (demoSensors) _SensorsDemo(),
                    if (demoWebWidgets) _WebWidgetsDemo(),
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

class _CameraDemo extends StatelessWidget {
  final bool demoStreaming;
  _CameraDemo({
    this.demoStreaming = true,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoverText(
          "Camera",
          bottomPadding: 8.0,
          topPadding: 8.0,
        ),
        demoStreaming
            ? CameraStreamWidget(
                onImage: (image) {
                  final timestamp = image.timestamp.formattedTime;
                  print("CameraStreamWidget image on: $timestamp");
                },
              )
            : CameraControllerWidget(
                builder: (context, initialization) {
                  switch (initialization.status) {
                    case CameraInitializationState.loading:
                      return CircularProgressIndicator();

                    case CameraInitializationState.initialized:
                      final controller = initialization.controller;
                      return SizedBox(
                        height: 300,
                        child: controller != null
                            ? CameraPreview(controller)
                            : Container(),
                      );

                    case CameraInitializationState.setupFailed:
                      return Text("Setup Failed!");

                    default:
                      return SizedBox.shrink();
                  }
                },
              ),
      ],
    );
  }
}

class _SensorsDemo extends StatelessWidget {
  Widget _buildSensorInfo(
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
                bottomPadding: 8.0,
                topPadding: 8.0,
              ),
              HoverText(
                  "X:" + (sensorData != null ? sensorData.x.toString() : "")),
              HoverText(
                  "Y:" + (sensorData != null ? sensorData.y.toString() : "")),
              HoverText(
                  "Z:" + (sensorData != null ? sensorData.z.toString() : "")),
              HoverCallToActionButton(
                text: controller.isWatching ? "Stop" : "Start",
                onPressed: () {
                  print("asd");
                  controller.toggleMonitoring();
                },
              )
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccelerometerWidget(builder: _buildSensorInfo),
        GyroscopeWidget(builder: _buildSensorInfo),
      ],
    );
  }
}

class _WebWidgetsDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebWidgetsDemoState();
}

class _WebWidgetsDemoState extends State<_WebWidgetsDemo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoverText(
          "WebSocket",
          bottomPadding: 8.0,
          topPadding: 8.0,
        ),
        SizedBox(
          width: Hover.getScreenWidth(context),
          child: WebSocketMonitor(
            webSocket: WebSocket(host: "192.168.100.191", port: 6868),
            builder: (context, event) {
              if (event != null) {
                if (event is WebSocketMessageEvent) {
                  final message = event.message;
                  if (message.type == "buffer") {
                    final List<dynamic> data = jsonDecode(message.body!);
                    final List<int> ints = data.map((i) => i as int).toList();
                    final bytes = Uint8List.fromList(ints);
                    return Image.memory(
                      bytes,
                      errorBuilder: (_, err, ___) => SizedBox.shrink(),
                    );
                  }
                  return Text(message.body ?? "");
                }

                if (event is WebSocketErrorEvent) {
                  return Text(event.error?.toString() ?? "");
                }
              }
              return Column(children: [Text(event.runtimeType.toString())]);
            },
          ),
        ),
      ],
    );
  }
}
