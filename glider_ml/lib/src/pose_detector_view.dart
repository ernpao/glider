import 'package:flutter/material.dart';
import 'package:glider_sensors/glider_sensors.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hover/hover.dart';

import 'machine_learning_helper.dart';

class PoseDetectorView extends StatelessWidget {
  PoseDetectorView({
    Key? key,
    required this.overlayBuilder,
  }) : super(key: key);

  /// Builder for each pose detected.
  final Widget Function(
    BuildContext context,
    Pose pose,
    Size imageSize,
    Size containerSize,
  ) overlayBuilder;

  final _PoseDetector _poseDetector = _PoseDetector(processingInterval: 100);

  @override
  Widget build(BuildContext context) {
    return CameraViewBuilder(
      resolution: ResolutionPreset.max,
      onImage: _poseDetector.detectPose,
      builder: (context, viewController) {
        return CameraPreview(
          viewController.cameraController,
          child: _PoseDetectorProvider(
            poseDetector: _poseDetector,
            child: _PoseDetectorOverlay(overlayBuilder: overlayBuilder),
          ),
        );
      },
    );
  }
}

class _PoseDetector extends ChangeNotifier {
  _PoseDetector({required this.processingInterval});

  /// Processing interval in milliseconds.
  final int processingInterval;

  /// Timestamp of this pose recognition process.
  DateTime _previousDetectionTime = DateTime.now();

  /// Results of the last pose recognition process.
  _PoseDetectorResult? get latestResult => _lastestResult;
  _PoseDetectorResult? _lastestResult;

  void detectPose(CameraOutput imageData) async {
    final currentTime = DateTime.now();
    final timeElapsed =
        currentTime.difference(_previousDetectionTime).inMilliseconds;

    if (timeElapsed > processingInterval) {
      _previousDetectionTime = currentTime;

      final cameraImage = imageData.cameraImage;
      final cameraDescription = imageData.cameraDescription;
      final inputImage = MachineLearningHelper.convertCameraImage(
        cameraImage,
        cameraDescription,
      );

      final result = await MachineLearningHelper.detectPose(inputImage);

      // Store the detected poses and notify listeners.
      _lastestResult = _PoseDetectorResult(
        inputImage: inputImage,
        detectedPoses: result,
      );

      notifyListeners();

      /// Calculate the processing time
      final processEnd = DateTime.now();
      final processMs = processEnd.difference(currentTime).inMilliseconds;
      print("Pose recognition processing time: ${processMs}ms");
    }
  }
}

class _PoseDetectorProvider extends ChangeNotifierProvider<_PoseDetector> {
  _PoseDetectorProvider({
    Widget? child,
    required _PoseDetector poseDetector,
  }) : super(
          create: (_) => poseDetector,
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
    Pose pose,
    Size imageSize,
    Size containerSize,
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
          final imageData = detectionResult.inputImage.inputImageData!;
          final imageSize = imageData.size;

          // /// Image is rotated 90 Deg by default, so we
          // /// flip width and height
          final imageWidth = imageSize.height;
          final imageHeight = imageSize.width;
          print("Image W: $imageWidth H: $imageHeight");

          final poses = detectionResult.detectedPoses;
          print("Poses detected: ${poses.length}");

          if (poses.length > 0) {
            final pose = poses.first;

            overlays = [
              overlayBuilder(
                context,
                pose,
                Size(imageWidth, imageHeight),
                Size(containerWidth, containerHeight),
              )
            ];

            // final landmarks = pose.landmarks;
            // landmarks.forEach((landmarkType, landmark) {
            //   final x = (landmark.x / imageWidth) * containerWidth;
            //   final y = (landmark.y / imageHeight) * containerHeight;

            //   print("    ${landmarkType.name}");
            //   overlays.add(AnimatedPositioned(
            //     duration: Duration(milliseconds: 100),
            //     top: y,
            //     left: x,
            //     child: Column(
            //       children: [
            //         overlayBuilder(context),
            //         HoverText(landmarkType.name, fontSize: 6),
            //       ],
            //     ),
            //   ));
            // });
          }
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
