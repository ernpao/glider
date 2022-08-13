import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

import 'apis/apis.dart';

/// A widget for rendering live images from
/// buffer (Uint8 array) data stream.
/// Data is received from a "Webtop Buffer Source" (ex. ESP32-CAM)
/// sent to the Webtop server.
class WebtopLiveImage extends StatefulWidget {
  const WebtopLiveImage({
    Key? key,
    required this.interface,
    required this.width,
    required this.height,
    this.onImage,
  }) : super(key: key);

  /// Interface used to connect with the Webtop server.
  final WebtopWebAPI interface;

  /// Expected width of the image that will be rendered.
  final double width;

  /// Expected height of the image that will be rendered.
  final double height;

  final Function(List<int> buffer, ui.Image uiImage)? onImage;

  @override
  _WebtopLiveImageState createState() => _WebtopLiveImageState();
}

class _WebtopLiveImageState extends State<WebtopLiveImage> {
  @override
  Widget build(BuildContext context) {
    return WsDataMonitor(
      socket: widget.interface,
      builder: (context, event) {
        if (event != null) {
          if (event.isDataEventWithData) {
            final messageEvent = event.asDataEvent();
            final message = messageEvent.data!;
            if (message.hasBody && message.sender == "Webtop Buffer Source") {
              final json = JSON.parse(message.body!);
              final data = json.getProperty<List>("data");
              if (data != null) {
                final intList = _convertToIntList(data);
                return FutureBuilder<Widget>(
                  future: _buildImage(context, intList),
                  builder: (context, snapshot) => snapshot.data!,
                );
              }
            }
          }
        }
        return SizedBox(
          width: widget.width,
          height: widget.height,
        );
      },
    );
  }

  List<int> _convertToIntList(List data) {
    final intList = data.map((i) => int.parse(i.toString())).toList();
    return intList;
  }

  ui.Image? _previousFrame;

  Future<Widget> _buildImage(BuildContext context, List<int> frameBytes) async {
    final bytes = Uint8List.fromList(frameBytes);

    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;

      _previousFrame = image;

      if (widget.onImage != null) {
        widget.onImage!(frameBytes, image);
      }

      return CustomPaint(
        painter: _ImagePainter(image),
        size: Size(widget.width, widget.height),
      );
    } catch (e) {
      // print(e.toString());
      if (_previousFrame != null) {
        return CustomPaint(
          painter: _ImagePainter(_previousFrame!),
          size: Size(widget.width, widget.height),
        );
      } else {
        return Container(
          color: Colors.black,
          width: widget.width,
          height: widget.height,
        );
      }
    }
  }
}

class _ImagePainter extends CustomPainter {
  final ui.Image image;

  _ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(oldDelegate) => false;
}
