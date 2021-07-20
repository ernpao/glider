import 'dart:convert';

import 'package:flutter/material.dart';
import 'glider_webtop.dart';

void main() {
  runApp(const GliderWebtopDemo());
}

class GliderWebtopDemo extends StatefulWidget {
  const GliderWebtopDemo({Key? key}) : super(key: key);

  @override
  State<GliderWebtopDemo> createState() => _GliderWebtopDemoState();
}

int _sample = 0;

class _GliderWebtopDemoState extends State<GliderWebtopDemo> {
  final socket = WebtopAPI(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  @override
  Widget build(BuildContext context) {
    return Application(
      theme: ThemeData.dark(),
      child: Column(
        children: [
          CameraViewBuilder(
            onImage: (image) async {
              if (_sample++ > 5) {
                final bytes = image.cameraImage.bytes;
                if (socket.isClosed) socket.openSocket();
                socket.send(jsonEncode(bytes), type: "bus");
              }
              _sample = 0;
            },
            builder: (context, viewController) {
              return CameraPreview(viewController.cameraController);
            },
          ),
          WebSocketMonitor(
            webSocket: WebtopAPI(
              host: "192.168.100.191",
              port: 6767,
              socketPort: 6868,
            ),
            builder: (context, event) {
              if (event != null) {
                if (event.isMessageEvent) {}
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      useMaterialAppWidget: true,
    );
  }
}
