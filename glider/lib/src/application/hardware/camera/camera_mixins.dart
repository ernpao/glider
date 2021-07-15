import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;

const _shift = (0xFF << 24);
final imglib.PngEncoder _pngEncoder =
    new imglib.PngEncoder(level: 0, filter: 0);

extension CameraImageExtension on CameraImage {
  Uint8List? convertYUV420toImageColor() {
    try {
      final int uvRowStride = planes[1].bytesPerRow;
      final int uvPixelStride = planes[1].bytesPerPixel!;

      // print("uvRowStride: " + uvRowStride.toString());
      // print("uvPixelStride: " + uvPixelStride.toString());

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

      List<int> png = _pngEncoder.encodeImage(img);
      Uint8List bytes = Uint8List.fromList(png);
      return bytes;
      // muteYUVProcessing = false;
      // return Image.memory(bytes);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }
}
