import 'package:flutter/material.dart';
import 'package:glider_sensors/glider_sensors.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

import 'machine_learning_helper.dart';

class PoseDetectorView extends StatelessWidget {
  PoseDetectorView({
    Key? key,
    required this.overlayBuilder,
  }) : super(key: key);

  /// Builder for each text block detected.
  final Widget Function(
    BuildContext context,
    String detectedText,
  ) overlayBuilder;

  final _PoseDetector _textDetector = _PoseDetector(processingInterval: 1500);

  @override
  Widget build(BuildContext context) {
    return CameraViewBuilder(
      resolution: ResolutionPreset.max,
      onImage: _textDetector.detectPose,
      builder: (context, viewController) {
        return CameraPreview(
          viewController.cameraController,
          child: _PoseDetectorProvider(
            textDetector: _textDetector,
            child: _PoseDetectorOverlay(overlayBuilder: overlayBuilder),
          ),
        );
      },
    );
  }
}

class _PoseDetector extends ChangeNotifier {
  _PoseDetector({
    required this.processingInterval,
  });

  /// Processing interval in milliseconds.
  final int processingInterval;

  /// Timestamp of the last text recognition process.
  DateTime _lastProcessTimestamp = DateTime.now();

  /// Results of the last text recognition process.
  _PoseDetectorResult? get latestResult => _lastestResult;
  _PoseDetectorResult? _lastestResult;

  void detectPose(CameraImageData imageData) async {
    final processCalledOn = DateTime.now();
    final timeElapsedSinceLastProcess =
        processCalledOn.difference(_lastProcessTimestamp).inMilliseconds;

    if (timeElapsedSinceLastProcess > processingInterval) {
      _lastProcessTimestamp = processCalledOn;

      final cameraImage = imageData.cameraImage;
      final cameraDescription = imageData.cameraDescription;
      final inputImage = MachineLearningHelper.convertCameraImage(
        cameraImage,
        cameraDescription,
      );

      final result = await MachineLearningHelper.detectPose(inputImage);

      _lastestResult = _PoseDetectorResult(
        inputImage: inputImage,
        detectedPoses: result,
      );

      notifyListeners();

      /// Calculate the processing time
      final processEnd = DateTime.now();
      final processMs = processEnd.difference(processCalledOn).inMilliseconds;
      print("Text recognition processing time: ${processMs}ms");
    }
  }
}

class _PoseDetectorProvider extends ChangeNotifierProvider<_PoseDetector> {
  _PoseDetectorProvider({
    Widget? child,
    required _PoseDetector textDetector,
  }) : super(
          create: (_) => textDetector,
          child: child,
        );
}

class _PoseDetectorResult {
  _PoseDetectorResult({
    required this.detectedPoses,
    required this.inputImage,
  });
  final List<Pose> detectedPoses;
  final InputImage inputImage;
}

class _PoseDetectorOverlay extends StatelessWidget {
  _PoseDetectorOverlay({
    required this.overlayBuilder,
  });

  /// Builder function for each text block detected. Used to draw
  /// overlays on top of the live camera preview.
  final Widget Function(
    BuildContext context,
    String detectedText,
  ) overlayBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final poseDetector = Provider.of<_PoseDetector>(context);
        final detectionResult = poseDetector.latestResult;
        List<Widget> overlays = [];

        final containerWidth = constraints.smallest.width;
        final containerHeight = constraints.smallest.height;
        print("Overlay W: $containerWidth H: $containerHeight");

        if (detectionResult != null) {
          // final imageData = detectionResult.inputImage.inputImageData!;
          // final imageSize = imageData.size;

          // /// Image is rotated 90 Deg by default, so we
          // /// flip width and height
          // final imageWidth = imageSize.height;
          // final imageHeight = imageSize.width;

          final poses = detectionResult.detectedPoses;

          poses.forEach((pose) {
            // final blockRect = pose.rect;
            // final x = (blockRect.topLeft.dx / imageWidth) * containerWidth;
            // final y = (blockRect.topLeft.dy / imageHeight) * containerHeight;
            // return AnimatedPositioned(
            //   duration: Duration(milliseconds: 100),
            //   top: y,
            //   left: x,
            //   child: overlayBuilder(context, pose.text),
            // );
            // return SizedBox.shrink();

            /// TODO: Process pose landmarks and create overlay widgets.
            final landmarks = pose.landmarks;
            landmarks.forEach((landmarkType, landmark) {});

            final overlay = SizedBox.shrink();

            overlays.add(overlay);
          });
        }

        return Container(
          width: containerWidth,
          height: containerHeight,
          child: Stack(children: overlays),
        );
      },
    );
  }
}
