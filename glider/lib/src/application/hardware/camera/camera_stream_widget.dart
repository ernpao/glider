import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:glider_models/glider_models.dart';

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
  bool _platformUnsupported = false;

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
    if (_isLoading || _setupFailed || _platformUnsupported)
      return SizedBox.shrink();
    return widget.showPreview ? CameraPreview(_controller!) : SizedBox.shrink();
  }
}

class CameraStreamData extends JSON with EnumToString {
  final int width;
  final int height;
  final Uint8List bytes;
  final ImageFormatGroup imageFormatGroup;
  final ResolutionPreset resolution;
  final DateTime timestamp = DateTime.now();
  String get encodedBytes => jsonEncode(bytes);
  CameraStreamData({
    required this.width,
    required this.height,
    required this.bytes,
    required this.imageFormatGroup,
    required this.resolution,
  }) {
    set("width", width);
    set("height", width);
    // set("bytes", encodedBytes);
    set("imageFormatGroup", enumToString(imageFormatGroup));
    set("resolution", enumToString(resolution));
    set("timestamp", timestamp.toString());
  }
}

class CameraStreamDataRenderer extends StatelessWidget {
  CameraStreamDataRenderer({
    required this.data,
  });
  final CameraStreamData data;
  @override
  Widget build(BuildContext context) {
    return Image.memory(
      data.bytes,
      errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
    );
  }
}
