import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:glider_webtop/glider_webtop.dart';

import 'webtop_client.dart';

class BufferSourceImageStream extends StatefulWidget {
  final WebtopClient interface;
  const BufferSourceImageStream({
    Key? key,
    required this.interface,
  }) : super(key: key);

  @override
  _BufferSourceImageStreamState createState() =>
      _BufferSourceImageStreamState();
}

class _BufferSourceImageStreamState extends State<BufferSourceImageStream> {
  @override
  Widget build(BuildContext context) {
    return WebSocketMonitor(
      webSocket: widget.interface,
      builder: (context, event) {
        if (event != null) {
          if (event.isMessageEvent) {
            final e = event.asMessageEvent();
            final message = e.message;
            if (message.hasBody) {
              if (message.sender == "Buffer Source") {
                final json = JSON.parse(message.body!);
                final bytes = json.get("data").toString().toUint8List();
                return Center(
                  child: Image.memory(
                    bytes,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                );
              }
            }
          }
        }
        return const Center(child: Text("No Data"));
      },
    );
  }
}
