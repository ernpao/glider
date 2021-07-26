import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

import 'apis/apis.dart';

/// A widget for rendering "Buffer Source" data
/// sent by the Webtop server.
class BufferSourceImageStream extends StatefulWidget {
  const BufferSourceImageStream({
    Key? key,
    required this.interface,
    this.width,
    this.height,
  }) : super(key: key);

  /// Interface used to connect with the Webtop server.
  final WebtopWebAPI interface;

  /// Expected width of the image that will be rendered.
  final double? width;

  /// Expected height of the image that will be rendered.
  final double? height;

  @override
  _BufferSourceImageStreamState createState() =>
      _BufferSourceImageStreamState();
}

class _BufferSourceImageStreamState extends State<BufferSourceImageStream> {
  final List<Uint8List> _buffer = [];

  void _pushToStream(Uint8List bytes) {
    _buffer.add(bytes);
    if (_buffer.length > 10) {
      _buffer.removeAt(0);
    }
  }

  Widget _empty() => SizedBox(width: widget.width, height: widget.height);

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
                final json = JSONParser().parse(message.body!);
                final bytes = json.get("data").toString().toUint8List();
                _pushToStream(bytes);
                return Image.memory(
                  bytes,
                  height: widget.height,
                  width: widget.width,
                  errorBuilder: (context, exception, stackTrace) {
                    /// Discard the last item stored and make an
                    /// attempt to use the last valid item in `_buffer`
                    _buffer.removeLast();
                    return Image.memory(
                      _buffer.last,
                      height: widget.height?.toDouble(),
                      width: widget.width?.toDouble(),
                      errorBuilder: (context, error, stackTrace) {
                        /// Still unnable to use the last item in the `_buffer`
                        /// so just use an empty widget.
                        return _empty();
                      },
                    );
                  },
                );
              }
            }
          }
        }
        return _empty();
      },
    );
  }
}
