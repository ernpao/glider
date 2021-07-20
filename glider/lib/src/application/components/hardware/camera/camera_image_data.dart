import 'package:camera/camera.dart';

class CameraImageData {
  CameraImageData({
    required this.cameraImage,
    required this.cameraDescription,
    required this.imageFormatGroup,
    required this.resolution,
  });

  /// The camera that was used to take this image.
  final CameraDescription cameraDescription;

  final CameraImage cameraImage;

  final ImageFormatGroup imageFormatGroup;

  final ResolutionPreset resolution;

  /// Time when this [CameraImageData] was created.
  final DateTime createdOn = DateTime.now();

  /// Width of the [cameraImage] property of this [CameraImageData].
  int get width => cameraImage.width;

  /// Height of the [cameraImage] property of this [CameraImageData].
  int get height => cameraImage.height;
}
