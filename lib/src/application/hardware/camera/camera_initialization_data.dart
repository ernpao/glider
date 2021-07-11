import 'package:camera/camera.dart';

/// Indicates whether the initialization and fetching
/// of available cameras is in progress (loading),
/// completed (initialized), or failed (setupFailed).
enum CameraInitializationState {
  loading,
  initialized,
  setupFailed,
}

/// Describes the current state of initialization for the cameras.
class CameraInitializationData {
  final CameraInitializationState status;
  final CameraController? controller;
  final List<CameraDescription>? availableCameras;

  CameraInitializationData({
    required this.status,
    this.controller,
    this.availableCameras,
  });

  bool get isInitialized => status == CameraInitializationState.initialized;
  bool get isLoading => status == CameraInitializationState.loading;
  bool get failed => status == CameraInitializationState.setupFailed;
  bool get withController => controller != null;
  bool get camerasAvailable => availableCameras?.isNotEmpty ?? false;
}
