import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

import 'camera_mixins.dart';

class CameraStreamWidget extends StatefulWidget {
  CameraStreamWidget({
    this.onImage,
    this.showPreview = true,
    this.resolution = ResolutionPreset.low,
    this.imageFormatGroup = ImageFormatGroup.yuv420,
  });
  final bool showPreview;
  final Function(CameraStreamData image)? onImage;
  final ResolutionPreset resolution;

  /// When null the imageFormat will fallback to the platforms default.
  final ImageFormatGroup imageFormatGroup;
  @override
  _CameraStreamWidgetState createState() => _CameraStreamWidgetState();
}

class _CameraStreamWidgetState extends State<CameraStreamWidget> {
  CameraController? _controller;
  bool _setupFailed = false;
  bool _setupComplete = false;

  bool _isListening = true;
  @override
  void initState() {
    _initCameras();
    super.initState();
  }

  CameraController _createDefaultController(
      List<CameraDescription> availableCameras) {
    final controller = CameraController(
      availableCameras.first,
      widget.resolution,
      imageFormatGroup: widget.imageFormatGroup,
    );
    return controller;
  }

  void _onImage(CameraImage image) async {
    if (_isListening) {
      final bytes = image.convertYUV420toImageColor();

      if (bytes != null) {
        final data = CameraStreamData(
          width: image.width,
          height: image.height,
          bytes: bytes,
          imageFormatGroup: widget.imageFormatGroup,
          resolution: widget.resolution,
        );
        widget.onImage?.call(data);
      }
    }
  }

  // void _toggleStream() {
  //   setState(() {
  //     _isListening = !_isListening;
  //   });
  // }

  void _initCameras() async {
    final deviceCameras = await availableCameras();
    _controller = _createDefaultController(deviceCameras);
    _controller?.initialize().then((_) {
      if (mounted) {
        _controller?.startImageStream(_onImage);
      }
      setState(() {
        _setupFailed = !mounted;
        _setupComplete = true;
      });
    });
  }

  @override
  void dispose() {
    if (mounted) _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  bool get _isLoading => !_setupComplete;

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _setupFailed) return SizedBox.shrink();
    return widget.showPreview ? CameraPreview(_controller!) : SizedBox.shrink();
  }
}

class CameraStreamData {
  final int width;
  final int height;
  final Uint8List bytes;
  final ImageFormatGroup imageFormatGroup;
  final ResolutionPreset resolution;
  final DateTime timestamp = DateTime.now();
  CameraStreamData({
    required this.width,
    required this.height,
    required this.bytes,
    required this.imageFormatGroup,
    required this.resolution,
  });
}
