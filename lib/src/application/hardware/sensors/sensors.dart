library sensors;

/// Expose external dependencies
export 'package:sensors_plus/sensors_plus.dart';

/// Export Glider sensor library widgets
export 'sensor_monitor_widget.dart';

/// Imports for custom classes and extensions in this file
import 'package:sensors_plus/sensors_plus.dart';

/// Helper class for mobile sensors.
class _SensorManager {
  static final List<SensorMonitor> _monitors = [];

  static bool _sensorsActive = false;
  static bool get _sensorsInactive => !_sensorsActive;

  static _addMonitor(SensorMonitor monitor) {
    if (monitor.isNotWatching) {
      _monitors.add(monitor);
      if (_sensorsInactive) _initializeSensors();
    }
  }

  static void _initializeSensors() {
    accelerometerEvents.listen((e) => _process<AccelerometerEvent>(e));
    gyroscopeEvents.listen((e) => _process<GyroscopeEvent>(e));
    _sensorsActive = true;
  }

  static bool _isWatching(SensorMonitor monitor) => _monitors.contains(monitor);

  static void _process<T>(e) {
    _monitors
        .where((l) => l.eventType == e.runtimeType)
        .forEach((l) => (l as SensorMonitor<T>).onData(e));
  }

  static void _removeMonitor(SensorMonitor monitor) {
    if (monitor.isWatching) {
      _monitors.remove(monitor);
    }
  }
}

mixin SensorMonitorInterface {
  /// Indicates if this object is listening to the sensor event stream.
  bool get isWatching;

  /// Indicates if this object is not listening to the sensor event stream.
  bool get isNotWatching => !isWatching;

  /// Start listening to sensor data.
  void monitor();

  /// Stop listening to sensor data.
  void stopMonitoring();

  /// Stops listening to sensor data if the monitor
  /// is currently listening and vice versa.
  void toggleMonitoring();
}

mixin SensorMonitorEvents {
  /// Function called when the monitor starts listening to the sensor event stream.
  void Function() get onWatchStarted;

  /// Function called when the monitor stops listening to the sensor event stream.
  void Function() get onWatchStopped;
}

abstract class SensorMonitor<T>
    with SensorMonitorInterface, SensorMonitorEvents {
  SensorMonitor({
    required this.onData,
  }) {
    assert(eventType == GyroscopeEvent || eventType == AccelerometerEvent);
  }

  /// The type of event that the sensor is currently set up to listen to.
  Type get eventType => T;

  /// The monitor's handler function for sensor events.
  final void Function(T event) onData;

  @override
  bool get isWatching => _SensorManager._isWatching(this);

  @override
  void monitor() {
    _SensorManager._addMonitor(this);
    onWatchStarted();
  }

  @override
  void stopMonitoring() {
    _SensorManager._removeMonitor(this);
    onWatchStopped();
  }

  @override
  void toggleMonitoring() => isWatching ? stopMonitoring() : monitor();
}

class GyroscopeMonitor extends SensorMonitor<GyroscopeEvent> {
  GyroscopeMonitor({
    required void Function(GyroscopeEvent) onData,
    required this.onWatchStarted,
    required this.onWatchStopped,
  }) : super(onData: onData);

  @override
  final void Function() onWatchStarted;

  @override
  final void Function() onWatchStopped;
}

class AccelerometerMonitor extends SensorMonitor<AccelerometerEvent> {
  AccelerometerMonitor({
    required void Function(AccelerometerEvent) onData,
    required this.onWatchStarted,
    required this.onWatchStopped,
  }) : super(onData: onData);

  @override
  final void Function() onWatchStarted;

  @override
  final void Function() onWatchStopped;
}
