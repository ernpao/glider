import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_initialization_data.dart';

/// A widget that fetches a lists of cameras available on the device
/// and provides [CameraInitializationData] to a builder function.
class CameraControllerWidget extends StatefulWidget {
  CameraControllerWidget({
    required this.builder,
    this.resolution = ResolutionPreset.low,
    this.imageFormatGroup = ImageFormatGroup.yuv420,
  });
  final ResolutionPreset resolution;

  /// When null the imageFormat will fallback to the platforms default.
  final ImageFormatGroup imageFormatGroup;

  final Widget Function(BuildContext, CameraInitializationData) builder;

  @override
  State<StatefulWidget> createState() => _CameraControllerWidgetState();
}

class _CameraControllerWidgetState extends State<CameraControllerWidget> {
  CameraController? _controller;
  List<CameraDescription>? _availableCameras;
  bool _setupFailed = false;
  bool _setupComplete = false;

  @override
  void initState() {
    _initCameras();
    super.initState();
  }

  CameraController _createController(List<CameraDescription> availableCameras) {
    final controller = CameraController(
      availableCameras.first,
      widget.resolution,
      imageFormatGroup: widget.imageFormatGroup,
    );
    return controller;
  }

  void _initCameras() async {
    final deviceCameras = await availableCameras();
    _controller = _createController(deviceCameras);
    _controller?.initialize().then((_) {
      setState(() {
        _setupFailed = !mounted;
        _availableCameras = deviceCameras;
        _setupComplete = true;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool get _isLoading => !_setupComplete;

  @override
  Widget build(BuildContext context) {
    CameraInitializationState state;
    if (_isLoading) {
      state = CameraInitializationState.loading;
    } else {
      if (_setupFailed) {
        state = CameraInitializationState.setupFailed;
      } else {
        state = CameraInitializationState.initialized;
      }
    }

    CameraInitializationData data = CameraInitializationData(
      status: state,
      availableCameras: _availableCameras,
      controller: _controller,
    );

    return widget.builder(context, data);
  }
}
