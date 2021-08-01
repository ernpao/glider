import 'package:flutter/widgets.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'sensor_widget_controller.dart';

abstract class _SensorWidget<T extends SensorWidgetController>
    extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    dynamic data,
    SensorWidgetController? controller,
  ) builder;

  _SensorWidget({
    required this.builder,
  }) : assert(T == GyroscopeWidgetController ||
            T == AccelerometerWidgetController);

  Type get getListenerType => T;

  @override
  _SensorWidgetState createState() => _SensorWidgetState();
}

class _SensorWidgetState<T extends SensorWidgetController>
    extends State<_SensorWidget> {
  SensorWidgetController? _controller;

  dynamic _data;

  @override
  void initState() {
    final type = widget.getListenerType;
    if (type == GyroscopeWidgetController) {
      _controller = GyroscopeWidgetController(
        onData: _onData,
        onWatchStarted: _markDirty,
        onWatchStopped: _markDirty,
      );
    } else if (type == AccelerometerWidgetController) {
      _controller = AccelerometerWidgetController(
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

class GyroscopeWidget extends _SensorWidget<GyroscopeWidgetController> {
  GyroscopeWidget({
    required Widget Function(
      BuildContext context,
      GyroscopeEvent? data,
      GyroscopeWidgetController? controller,
    )
        builder,
  }) : super(
          builder: (context, data, controller) => builder(
            context,
            data as GyroscopeEvent?,
            controller as GyroscopeWidgetController?,
          ),
        );
}

class AccelerometerWidget extends _SensorWidget<AccelerometerWidgetController> {
  AccelerometerWidget({
    required Widget Function(
      BuildContext context,
      AccelerometerEvent? data,
      AccelerometerWidgetController? controller,
    )
        builder,
  }) : super(
          builder: (context, data, controller) => builder(
            context,
            data as AccelerometerEvent?,
            controller as AccelerometerWidgetController?,
          ),
        );
}

class AccelerometerStream extends StatelessWidget {
  const AccelerometerStream({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(
      BuildContext context, AsyncSnapshot<AccelerometerEvent> snapshot) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccelerometerEvent>(
      stream: accelerometerEvents.asBroadcastStream(),
      builder: builder,
    );
  }
}

class GyroscopeStream extends StatelessWidget {
  const GyroscopeStream({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(
      BuildContext context, AsyncSnapshot<GyroscopeEvent> snapshot) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GyroscopeEvent>(
      stream: gyroscopeEvents.asBroadcastStream(),
      builder: builder,
    );
  }
}
