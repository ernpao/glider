import 'package:flutter/widgets.dart';

import 'camera_output.dart';
import 'camera_image_extension.dart';

/// A widget for rendering the [CameraOutput] taken
/// from a camera.
class CameraOutputRenderer extends StatelessWidget {
  CameraOutputRenderer({
    required this.image,
  });
  final CameraOutput image;
  @override
  Widget build(BuildContext context) {
    final bytes = image.cameraImage.bytes;
    return Image.memory(
      bytes,
      errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
    );
  }
}
