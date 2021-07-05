library hardware;

export 'package:camera/camera.dart';
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

/// Helper class for mobile phone hardware such as sensors, cameras, etc.
class SensorManager {
  static final List<SensorListener> _sensorListeners = [];
  // static final List<StreamSubscription> _subsciptions = [];

  static Stream<AccelerometerEvent> get _accelerometer => accelerometerEvents;

  static Stream<GyroscopeEvent> get _gyroscope => gyroscopeEvents;

  static bool _sensorsActive = false;
  static bool get _sensorsInactive => !_sensorsActive;

  static _addListener(SensorListener listener) {
    _sensorListeners.add(listener);
    if (_sensorsInactive) _initializeSensors();
  }

  static void _initializeSensors() {
    _accelerometer.listen((e) => _process<AccelerometerEvent>(e));
    _gyroscope.listen((e) => _process<GyroscopeEvent>(e));
    _sensorsActive = true;
  }

  static bool _isListening(SensorListener listener) =>
      _sensorListeners.contains(listener);

  static void _process<T>(e) {
    _sensorListeners
        .where((l) => l.eventType == e.runtimeType)
        .forEach((l) => (l as SensorListener<T>).process(e));
  }

  static void _removeListener(SensorListener listener) {
    _sensorListeners.remove(listener);
  }
}

abstract class SensorListener<T> {
  SensorListener({required this.process}) {
    assert(eventType == GyroscopeEvent || eventType == AccelerometerEvent);
    listen();
  }

  Type get eventType => T;
  final void Function(T event) process;

  void listen() => SensorManager._addListener(this);
  void stopListening() => SensorManager._removeListener(this);
  void toggleListen() =>
      SensorManager._isListening(this) ? stopListening() : listen();
}

class GyroscopeListener extends SensorListener<GyroscopeEvent> {
  GyroscopeListener({required void Function(GyroscopeEvent) onSensorEvent})
      : super(process: onSensorEvent);
}

class AccelerometerListener extends SensorListener<AccelerometerEvent> {
  AccelerometerListener(
      {required void Function(AccelerometerEvent) onSensorEvent})
      : super(process: onSensorEvent);
}
