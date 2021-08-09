import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

import 'apis/apis.dart';

/// A widget for rendering "Buffer Source" data
/// received from the Webtop server.
class BufferSourceLiveImage extends StatefulWidget {
  const BufferSourceLiveImage({
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
  _BufferSourceLiveImageState createState() => _BufferSourceLiveImageState();
}

class _BufferSourceLiveImageState extends State<BufferSourceLiveImage> {
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
    return WsDataMonitor(
      socket: widget.interface,
      builder: (context, event) {
        if (event != null) {
          if (event.isDataEventWithData) {
            final messageEvent = event.asDataEvent();
            final message = messageEvent.data;
            if (message!.hasBody && message.sender == "Buffer Source") {
              final json = JSON.parse(message.body!);
              final data = json.getProperty<String>("data");
              if (data != null) {
                final bytes = data.toUint8List();
                if (bytes != null) _buildImage(bytes);
              }
            }
          }
        }
        return _empty();
      },
    );
  }

  Widget _buildImage(Uint8List bytes) {
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
