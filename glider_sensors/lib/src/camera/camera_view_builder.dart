import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_output.dart';

class CameraViewBuilder extends StatefulWidget {
  CameraViewBuilder({
    required this.builder,
    this.onImage,
    this.initialDirection = CameraLensDirection.back,
    this.resolution = ResolutionPreset.low,
    this.imageFormatGroup = ImageFormatGroup.yuv420,
  });
  final ResolutionPreset resolution;

  /// When null the imageFormat will fallback to the platform's default setting.
  final ImageFormatGroup imageFormatGroup;

  /// Determines which camera to use upon initialization (i.e. front or rear).
  final CameraLensDirection initialDirection;

  final Function(CameraOutput image)? onImage;

  final Function(BuildContext context, CameraViewController viewController)
      builder;

  @override
  State<StatefulWidget> createState() => _CameraViewBuilderState();
}

class _CameraViewBuilderState extends State<CameraViewBuilder> {
  CameraController? _controller;
  late List<CameraDescription> _availableCameras;

  @override
  void initState() {
    _initCameras();
    super.initState();
  }

  void _initCameras() async {
    _availableCameras = await availableCameras();
    await _startLiveFeed(widget.initialDirection);
  }

  Future<void> _startLiveFeed(CameraLensDirection lensDirection) async {
    int cameraIndex = 0;

    for (var i = 0; i < _availableCameras.length; i++) {
      if (_availableCameras[i].lensDirection == widget.initialDirection) {
        cameraIndex = i;
      }
    }

    _controller = CameraController(
      _availableCameras[cameraIndex],
      widget.resolution,
      imageFormatGroup: widget.imageFormatGroup,
      enableAudio: false,
    );

    await _controller?.initialize();

    if (mounted) {
      _controller?.startImageStream((image) {
        widget.onImage?.call(CameraOutput(
          cameraImage: image,
          cameraDescription: _controller!.description,
          imageFormatGroup: widget.imageFormatGroup,
          resolution: widget.resolution,
        ));
      });
    }

    setState(() {});
  }

  Future<void> _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      return widget.builder(
        context,
        CameraViewController(
          cameraController: _controller!,
          switchToFrontCamera: () async {
            await _stopLiveFeed();
            await _startLiveFeed(CameraLensDirection.front);
          },
          switchToRearCamera: () async {
            await _stopLiveFeed();
            await _startLiveFeed(CameraLensDirection.back);
          },
        ),
      );
    }
    return SizedBox.shrink();
  }
}

class CameraViewController {
  CameraViewController({
    required this.switchToFrontCamera,
    required this.switchToRearCamera,
    required this.cameraController,
  });

  final CameraController cameraController;
  final Future Function() switchToFrontCamera;
  final Future Function() switchToRearCamera;
}
