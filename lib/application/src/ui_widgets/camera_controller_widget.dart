import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A widget that fetches a lists of cameras available on the device
class CameraControllerWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    CameraController controller,
    List<CameraDescription> availableCameras,
  ) builder;

  /// Builder for the widget to display while the cameras
  /// are being setup.
  final Widget Function(BuildContext context) onSetupBuilder;

  /// Builder for the widget to display when the setup of cameras fails.
  /// An empty widget (i.e. SizedBox.shrink()) is displayed by default.
  final Widget Function(BuildContext context)? onSetupFailedBuilder;

  CameraControllerWidget({
    required this.builder,
    required this.onSetupBuilder,
    this.onSetupFailedBuilder,
  });

  @override
  State<StatefulWidget> createState() => _CameraControllerWidgetState();
}

class _CameraControllerWidgetState extends State<CameraControllerWidget> {
  late CameraController _controller;
  late List<CameraDescription> _availableCameras;
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
    _controller.initialize().then((_) {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_setupComplete) {
      return widget.onSetupBuilder(context);
    } else {
      if (_setupFailed) {
        return widget.onSetupFailedBuilder?.call(context) ?? SizedBox.shrink();
      } else {
        return widget.builder.call(context, _controller, _availableCameras);
      }
    }
  }
}
