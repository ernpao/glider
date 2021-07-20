import 'package:google_ml_kit/google_ml_kit.dart';

import '../components/hardware/camera/camera.dart';

final _textDetector = GoogleMlKit.vision.textDetector();
final _imageLabeler = GoogleMlKit.vision.imageLabeler();

class MachineLearningHelper {
  /// Creates an [InputImage] from the
  /// camera package's [CameraImage] and [CameraDescription]
  /// for use with the Google ML Kit package.
  static InputImage convertCameraImage(
      CameraImage image, CameraDescription camera) {
    final imageSize = image.size;
    final bytes = image.bytes;

    /// Determine the image rotation
    final sensorRotation = InputImageRotationMethods.fromRawValue(
      camera.sensorOrientation,
    );
    final imageRotation = sensorRotation ?? InputImageRotation.Rotation_0deg;

    /// Determine the image format
    final rawImageFormat = InputImageFormatMethods.fromRawValue(
      image.format.raw,
    );
    final inputImageFormat = rawImageFormat ?? InputImageFormat.NV21;

    /// Translate the image plane data
    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    /// Create the [InputImageData] metadata
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    /// Create the [InputImage] to return
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    return inputImage;
  }

  /// Google ML Kit text recognition.
  static Future<RecognisedText> recognizeText(InputImage inputImage) {
    return _textDetector.processImage(inputImage);
  }

  /// Google ML Kit image labeler.
  static Future<List<ImageLabel>> labelImage(InputImage inputImage) {
    return _imageLabeler.processImage(inputImage);
  }
}
