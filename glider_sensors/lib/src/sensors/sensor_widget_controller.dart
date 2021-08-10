import 'package:sensors_plus/sensors_plus.dart';

/// Helper class for mobile sensors.
class _SensorManager {
  static final List<SensorWidgetController> _monitors = [];

  static bool _sensorsActive = false;
  static bool get _sensorsInactive => !_sensorsActive;

  static _addMonitor(SensorWidgetController monitor) {
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

  static bool _isWatching(SensorWidgetController monitor) =>
      _monitors.contains(monitor);

  static void _process<T>(e) {
    _monitors
        .where((l) => l.eventType == e.runtimeType)
        .forEach((l) => (l as SensorWidgetController<T>).onData(e));
  }

  static void _removeMonitor(SensorWidgetController monitor) {
    if (monitor.isWatching) {
      _monitors.remove(monitor);
    }
  }
}

mixin _SensorControllerInterface {
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

  /// Function called when the monitor starts listening to the sensor event stream.
  void Function() get onWatchStarted;

  /// Function called when the monitor stops listening to the sensor event stream.
  void Function() get onWatchStopped;
}

abstract class SensorWidgetController<T> with _SensorControllerInterface {
  SensorWidgetController({required this.onData}) {
    if (!(eventType == GyroscopeEvent || eventType == AccelerometerEvent)) {
      throw new Exception(
        "Sensor monitor eventType is ${T.toString()}but should be GyroscopeEvent or AccelerometerEvent",
      );
    }
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

class GyroscopeWidgetController extends SensorWidgetController<GyroscopeEvent> {
  GyroscopeWidgetController({
    required void Function(GyroscopeEvent) onData,
    required this.onWatchStarted,
    required this.onWatchStopped,
  }) : super(onData: onData);

  @override
  final void Function() onWatchStarted;

  @override
  final void Function() onWatchStopped;
}

class AccelerometerWidgetController
    extends SensorWidgetController<AccelerometerEvent> {
  AccelerometerWidgetController({
    required void Function(AccelerometerEvent) onData,
    required this.onWatchStarted,
    required this.onWatchStopped,
  }) : super(onData: onData);

  @override
  final void Function() onWatchStarted;

  @override
  final void Function() onWatchStopped;
}
