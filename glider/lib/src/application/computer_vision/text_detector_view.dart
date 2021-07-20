import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/hardware/camera/camera.dart';
import 'computer_vision_helper.dart';

class TextDetectorView extends StatelessWidget {
  const TextDetectorView({
    Key? key,
    this.size,
  }) : super(key: key);

  final Size? size;

  @override
  Widget build(BuildContext context) {
    return _TextDetectorProvider(
      child: Builder(builder: (context) {
        final state = Provider.of<_TextDetectorModel>(context, listen: false);
        return SizedBox(
          width: size?.width,
          height: size?.height,
          child: Stack(
            children: [
              CameraViewBuilder(
                resolution: ResolutionPreset.max,
                onImage: (image) => state.recognizeText(image),
                builder: (context, viewController) {
                  return CameraPreview(viewController.cameraController);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _TextDetectorModel extends ChangeNotifier {
  DateTime lastSampleTime = DateTime.now();

  void recognizeText(CameraImageData imageData) async {
    final currentTime = DateTime.now();

    if (currentTime.difference(lastSampleTime).inMilliseconds > 3000) {
      lastSampleTime = currentTime;

      final processingStart = currentTime;

      final image = imageData.cameraImage;
      final camera = imageData.cameraDescription;
      final inputImage = ComputerVisionHelper.convertCameraImage(image, camera);

      print("Processing image");
      final recognizedText =
          await ComputerVisionHelper.recognizeText(inputImage);

      final processingEnd = DateTime.now();
      final processingMs =
          processingEnd.difference(processingStart).inMilliseconds;

      print(
          "Text blocks found: ${recognizedText.blocks.length}. Processing time: ${processingMs}ms");

      recognizedText.blocks.forEach((block) {
        print("Recognized Text: ${block.text}");
      });
    }
  }
}

class _TextDetectorProvider extends ChangeNotifierProvider<_TextDetectorModel> {
  _TextDetectorProvider({
    Widget? child,
  }) : super(
          create: (_) => _TextDetectorModel(),
          child: child,
        );
}
