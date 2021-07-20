import 'package:flutter/widgets.dart';

import 'camera_image_data.dart';
import 'camera_image_extension.dart';

class CameraImageDataRenderer extends StatelessWidget {
  CameraImageDataRenderer({
    required this.image,
  });
  final CameraImageData image;
  @override
  Widget build(BuildContext context) {
    final bytes = image.cameraImage.bytes;
    return Image.memory(
      bytes,
      errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
    );
  }
}
