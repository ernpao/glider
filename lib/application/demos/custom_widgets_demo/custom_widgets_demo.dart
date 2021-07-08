import 'package:flutter/material.dart';

import '../../../data/src/data_layer.dart';
import '../../../data/webtop_data_layer.dart';
import '../../src/application_layer.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoverText(
          "Camera",
          bottomPadding: 8.0,
          topPadding: 8.0,
        ),
        CameraControllerWidget(
          builder: (context, snapshot) {
            switch (snapshot.status) {
              case CameraControllerWidgetStatus.loading:
                return CircularProgressIndicator();

              case CameraControllerWidgetStatus.initialized:
                final controller = snapshot.controller;
                return SizedBox(
                  height: 300,
                  child: controller != null
                      ? CameraPreview(controller)
                      : Container(),
                );

              case CameraControllerWidgetStatus.setupFailed:
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
                onPressed: controller.toggleMonitoring,
              )
            ],
          )
        : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AccelerometerWidget(builder: _buildSensorWidget),
        GyroscopeWidget(builder: _buildSensorWidget),
      ],
    );
  }
}

class _WebWidgetsDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HoverText(
          "WebSocket",
          bottomPadding: 8.0,
          topPadding: 8.0,
        ),
        WebSocketWidget(
          webSocket: WebtopClient(
            host: "192.168.100.191",
            port: 6767,
            socketPort: 6868,
          ),
          retryOnDone: true,
          builder: (context, event, socket) {
            print('Is message? ${event?.isMessageEvent}');
            print('Is error? ${event?.isErrorEvent}');
            print('Is done? ${event?.isDoneEvent}');

            if (event != null) {
              if (event is WebSocketMessageEvent) {
                event.message.debug();
                return Text(event.message.data ?? "");
              }

              if (event is WebSocketDoneEvent) {
                return Column(
                  children: [
                    Text(event.runtimeType.toString()),
                    HoverCallToActionButton(
                      text: "Restart",
                      onPressed: () {},
                    )
                  ],
                );
              }

              if (event is WebSocketErrorEvent) {
                return Text(event.error?.toString() ?? "");
              }
            }

            return Container();
          },
        ),
      ],
    );
  }
}
