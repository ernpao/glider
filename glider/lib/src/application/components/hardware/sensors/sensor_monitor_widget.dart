import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'sensor_monitor.dart';

abstract class _SensorMonitorWidget<T extends SensorMonitor>
    extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    dynamic data,
    SensorMonitor? monitor,
  ) builder;

  _SensorMonitorWidget({
    required this.builder,
  }) : assert(T == GyroscopeMonitor || T == AccelerometerMonitor);

  Type get getListenerType => T;

  @override
  _SensorMonitorWidgetState createState() => _SensorMonitorWidgetState();
}

class _SensorMonitorWidgetState<T extends SensorMonitor>
    extends State<_SensorMonitorWidget> {
  SensorMonitor? _controller;

  dynamic _data;

  @override
  void initState() {
    final type = widget.getListenerType;
    if (type == GyroscopeMonitor) {
      _controller = GyroscopeMonitor(
        onData: _onData,
        onWatchStarted: _markDirty,
        onWatchStopped: _markDirty,
      );
    } else if (type == AccelerometerMonitor) {
      _controller = AccelerometerMonitor(
        onData: _onData,
        onWatchStarted: _markDirty,
        onWatchStopped: _markDirty,
      );
    }
    assert(_controller != null);
    super.initState();
  }

  void _markDirty() => setState(() {});

  void _onData(dynamic d) => setState(() => _data = d);

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _data, _controller);
}

class GyroscopeWidget extends _SensorMonitorWidget<GyroscopeMonitor> {
  GyroscopeWidget({
    required Widget Function(
      BuildContext context,
      GyroscopeEvent? data,
      GyroscopeMonitor? monitor,
    )
        builder,
  }) : super(
          builder: (context, data, monitor) => builder(
            context,
            data as GyroscopeEvent?,
            monitor as GyroscopeMonitor?,
          ),
        );
}

class AccelerometerWidget extends _SensorMonitorWidget<AccelerometerMonitor> {
  AccelerometerWidget({
    required Widget Function(
      BuildContext context,
      AccelerometerEvent? data,
      AccelerometerMonitor? monitor,
    )
        builder,
  }) : super(
          builder: (context, data, monitor) => builder(
            context,
            data as AccelerometerEvent?,
            monitor as AccelerometerMonitor?,
          ),
        );
}
