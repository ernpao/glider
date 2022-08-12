import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

import 'apis/apis.dart';

/// A widget for rendering "Buffer Source" data
/// received from the Webtop server.
class BufferSourceLiveImage extends StatefulWidget {
  const BufferSourceLiveImage({
    Key? key,
    required this.interface,
    required this.width,
    required this.height,
  }) : super(key: key);

  /// Interface used to connect with the Webtop server.
  final WebtopWebAPI interface;

  /// Expected width of the image that will be rendered.
  final double width;

  /// Expected height of the image that will be rendered.
  final double height;

  @override
  _framesSourceLiveImageState createState() => _framesSourceLiveImageState();
}

class _framesSourceLiveImageState extends State<BufferSourceLiveImage> {
  final List<Uint8List> _frames = [];

  Widget _empty() => Container(
        width: widget.width,
        height: widget.height,
        color: Colors.red,
      );

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
              // print(json.stringify());
              final data = json.getProperty<List>("data");
              if (data != null) {
                final intList =
                    data.map((i) => int.parse(i.toString())).toList();

                // print(intList);
                // print(data.length);

                final bytes = Uint8List.fromList(intList);

                if (bytes != null)
                  return FutureBuilder<Widget>(
                    future: _buildImage(context, intList),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      }
                      return SizedBox.shrink();
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

  Future<Widget> _buildImage(BuildContext context, List<int> frameBytes) async {
    // return CustomPaint(
    //   painter: _CustomImagePainter(frameBytes),
    //   size: Size(widget.width, widget.height),
    // );

    final bytes = Uint8List.fromList(frameBytes);

    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      return CustomPaint(
        painter: _CustomPainter(image),
        size: Size(widget.width, widget.height),
      );
    } catch (e) {
      print(e.toString());
      return Container(
        color: Colors.black,
        width: widget.width,
        height: widget.height,
      );
    }

    // //---------------------------------------------------------------------
    // _frames.add(bytes);
    // // print(bytes.length);
    // if (_frames.length > 10) _frames.removeAt(0);
    // return Image.memory(
    //   bytes,
    //   height: widget.height,
    //   width: widget.width,
    //   errorBuilder: (context, exception, stackTrace) {
    //     /// Discard the last item stored and make an
    //     /// attempt to use the last valid item in `_frames`
    //     if (_frames.length > 1) {
    //       _frames.removeLast();
    //     }

    //     final previousFrame = _frames.last;
    //     return Image.memory(
    //       previousFrame,
    //       height: widget.height,
    //       width: widget.width,
    //       errorBuilder: (context, error, stackTrace) {
    //         /// Still unable to use the last item in the `_frames`
    //         /// so just use an empty widget.
    //         return _empty();
    //       },
    //     );
    //   },
    // ); // END Image.memory
    // //---------------------------------------------------------------------
  }
}

class _CustomImagePainter extends CustomPainter {
  List<int> bytes;

  _CustomImagePainter(this.bytes);

  @override
  void paint(Canvas canvas, Size size) {
    double x = 0;
    double y = 0;
    final pixels = bytes.toIntList();
    // print(pixels.length);
    pixels.forEach((pixel) {
      /// 8 bit rgb = RRR GGG BB
      /// 3 bits R, 3 bits G, 2 bits B

      int r = (pixel) >> 5;
      int g = (pixel << 3) >> 5;
      int b = (pixel << 6) >> 8;
      int a = 255;
      // print([r, g, b]);
      Color color = Color.fromARGB(a, r, g, b);

      Paint paint = Paint();
      // paint.color = Colors.red;
      paint.color = color;

      canvas.drawRect(Rect.fromLTWH(x, y, 1, 1), paint);
      x++;
      if (x == (size.width - 1)) {
        y++;
        x = 0;
      }
      // print([x, y]);
    });
  }

  @override
  bool shouldRepaint(oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(oldDelegate) => false;
}

class _CustomPainter extends CustomPainter {
  final ui.Image image;

  _CustomPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(oldDelegate) => false;
}
