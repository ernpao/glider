import 'package:google_ml_kit/google_ml_kit.dart';

import '../components/hardware/camera/camera.dart';

final _textDetector = GoogleMlKit.vision.textDetector();
final _imageLabeler = GoogleMlKit.vision.imageLabeler();

class MachineLearningHelper {
  static InputImage convertCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final imageSize = image.size;
    final bytes = image.bytes;

    final imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    return inputImage;
  }

  static Future<RecognisedText> recognizeText(InputImage inputImage) {
    return _textDetector.processImage(inputImage);
  }

  static Future<List<ImageLabel>> labelImage(InputImage inputImage) {
    return _imageLabeler.processImage(inputImage);
  }
}
