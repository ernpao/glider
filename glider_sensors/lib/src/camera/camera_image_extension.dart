import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as imglib;

const _shift = (0xFF << 24);
final imglib.PngEncoder _pngEncoder =
    new imglib.PngEncoder(level: 0, filter: 0);

extension CameraImageExtension on CameraImage {
  Size get size => Size(width.toDouble(), height.toDouble());

  Uint8List get bytes {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    return bytes;
  }

  @deprecated
  Uint8List convertYUV420toImageColor() {
    List<int> png = [];
    final int uvRowStride = planes[1].bytesPerRow;
    final int uvPixelStride = planes[1].bytesPerPixel!;

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = planes[0].bytes[index];
        final up = planes[1].bytes[uvIndex];
        final vp = planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = _shift | (b << 16) | (g << 8) | r;
      }
    }
    png = _pngEncoder.encodeImage(img);
    return Uint8List.fromList(png);
  }
}
