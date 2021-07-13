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

class _GliderWebtopDemoState extends State<GliderWebtopDemo> {
  final socket = WebtopClient(
    name: "glider_webtop_demo",
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  @override
  Widget build(BuildContext context) {
    socket.openSocket(reconnectOnDone: true);
    return Application(
      theme: ThemeData.dark(),
      child: Column(
        children: [
          CameraStreamWidget(
            onImage: (image) async {
              if (image.timestamp.millisecond % 100 == 0) {
                // socket.send(image.encodedBytes);
                socket.send("test");
              }
            },
          ),
        ],
      ),
      useMaterialAppWidget: true,
    );
  }
}
