import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:glider_webtop/glider_webtop.dart';

void main() {
  runApp(const WebtopGliderDemo());
}

class WebtopGliderDemo extends StatefulWidget {
  const WebtopGliderDemo({Key? key}) : super(key: key);

  @override
  State<WebtopGliderDemo> createState() => _WebtopGliderDemoState();
}

class _WebtopGliderDemoState extends State<WebtopGliderDemo> {
  final socket = WebtopClient(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  @override
  Widget build(BuildContext context) {
    socket.openSocket();
    return Application(
      theme: ThemeData.dark(),
      child: Column(
        children: [
          CameraStreamWidget(
            onImage: (image) async {
              if (image.timestamp.millisecond % 100 == 0) {
                // socket.sendJson(image);
                socket.send(WebSocketMessage(
                  data: image.encodedBytes,
                ));
              }
            },
          ),
        ],
      ),
      useMaterialAppWidget: true,
    );
  }
}
