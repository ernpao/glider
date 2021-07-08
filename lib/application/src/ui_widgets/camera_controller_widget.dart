import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

export 'package:camera/camera.dart';

enum CameraControllerWidgetStatus {
  loading,
  initialized,
  setupFailed,
}

class CameraControllerWidgetSnapshot {
  final CameraControllerWidgetStatus status;
  final CameraController? controller;
  final List<CameraDescription>? availableCameras;

  CameraControllerWidgetSnapshot({
    required this.status,
    this.controller,
    this.availableCameras,
  });
}

/// A widget that fetches a lists of cameras available on the device
class CameraControllerWidget extends StatefulWidget {
  CameraControllerWidget({required this.builder});

  final Widget Function(BuildContext, CameraControllerWidgetSnapshot) builder;

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

  CameraController _createDefaultController(
      List<CameraDescription> availableCameras) {
    final controller = CameraController(
      availableCameras.first,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    return controller;
  }

  void _initCameras() async {
    final deviceCameras = await availableCameras();
    _controller = _createDefaultController(deviceCameras);
    _controller?.initialize().then((_) {
      if (!mounted) {
        _setupFailed = true;
      } else {
        _setupFailed = false;
        _availableCameras = deviceCameras;
      }
      setState(() {
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
    CameraControllerWidgetStatus state;
    if (_isLoading) {
      state = CameraControllerWidgetStatus.loading;
    } else {
      if (_setupFailed) {
        state = CameraControllerWidgetStatus.setupFailed;
      } else {
        state = CameraControllerWidgetStatus.initialized;
      }
    }

    CameraControllerWidgetSnapshot snapshot = CameraControllerWidgetSnapshot(
      status: state,
      availableCameras: _availableCameras,
      controller: _controller,
    );

    return widget.builder(context, snapshot);
  }
}
