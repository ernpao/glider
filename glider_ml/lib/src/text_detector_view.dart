import 'package:flutter/material.dart';
import 'package:glider_sensors/glider_sensors.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

import 'machine_learning_helper.dart';

class TextDetectorView extends StatelessWidget {
  TextDetectorView({
    Key? key,
    required this.overlayBuilder,
  }) : super(key: key);

  /// Builder for each text block detected.
  final Widget Function(
    BuildContext context,
    String detectedText,
  ) overlayBuilder;

  final _TextDetector _textDetector = _TextDetector(processingInterval: 1500);

  @override
  Widget build(BuildContext context) {
    return CameraViewBuilder(
      resolution: ResolutionPreset.max,
      onImage: _textDetector.recognizeText,
      builder: (context, viewController) {
        return CameraPreview(
          viewController.cameraController,
          child: _TextDetectorProvider(
            textDetector: _textDetector,
            child: _TextDetectorOverlay(overlayBuilder: overlayBuilder),
          ),
        );
      },
    );
  }
}

class _TextDetector extends ChangeNotifier {
  _TextDetector({
    required this.processingInterval,
  });

  /// Processing interval in milliseconds.
  final int processingInterval;

  /// Timestamp of the last text recognition process.
  DateTime _lastProcessTimestamp = DateTime.now();

  /// Results of the last text recognition process.
  _TextDetectorResult? get latestResult => _lastestResult;
  _TextDetectorResult? _lastestResult;

  void recognizeText(CameraImageData imageData) async {
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

      final result = await MachineLearningHelper.recognizeText(inputImage);

      _lastestResult = _TextDetectorResult(
        inputImage: inputImage,
        recognisedText: result,
      );

      notifyListeners();

      /// Calculate the processing time
      final processEnd = DateTime.now();
      final processMs = processEnd.difference(processCalledOn).inMilliseconds;
      print("Text recognition processing time: ${processMs}ms");
    }
  }
}

class _TextDetectorProvider extends ChangeNotifierProvider<_TextDetector> {
  _TextDetectorProvider({
    Widget? child,
    required _TextDetector textDetector,
  }) : super(
          create: (_) => textDetector,
          child: child,
        );
}

class _TextDetectorResult {
  _TextDetectorResult({
    required this.recognisedText,
    required this.inputImage,
  });
  final RecognisedText recognisedText;
  final InputImage inputImage;
}

class _TextDetectorOverlay extends StatelessWidget {
  _TextDetectorOverlay({
    required this.overlayBuilder,
  });

  /// Builder for each text block detected.
  final Widget Function(
    BuildContext context,
    String detectedText,
  ) overlayBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final modelState = Provider.of<_TextDetector>(context);
        final data = modelState.latestResult;
        List<Widget> children = [];

        final layoutWidth = constraints.smallest.width;
        final layoutHeight = constraints.smallest.height;
        print("Overlay W: $layoutWidth H: $layoutHeight");

        if (data != null) {
          final imageData = data.inputImage.inputImageData!;
          final imageSize = imageData.size;

          /// Image is rotated 90 Deg by default, so we
          /// flip width and height
          final imageWidth = imageSize.height;
          final imageHeight = imageSize.width;

          children = data.recognisedText.blocks.map((block) {
            final blockRect = block.rect;
            final x = (blockRect.topLeft.dx / imageWidth) * layoutWidth;
            final y = (blockRect.topLeft.dy / imageHeight) * layoutHeight;
            return AnimatedPositioned(
              duration: Duration(milliseconds: 100),
              top: y,
              left: x,
              child: overlayBuilder(context, block.text),
            );
          }).toList();
        }

        return Container(
          width: layoutWidth,
          height: layoutHeight,
          child: Stack(
            children: children,
          ),
        );
      },
    );
  }
}
