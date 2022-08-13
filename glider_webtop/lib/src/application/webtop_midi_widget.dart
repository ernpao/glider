import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

import 'apis/apis.dart';

/// Base class for a widget that sends MIDI Continous Control
/// messages to the remote Webtop server.
abstract class WebtopMidiWidget extends StatelessWidget {
  WebtopMidiWidget({
    Key? key,
    required this.interface,
    required this.parameters,
    this.onChanged,
    this.showChannelLabel = true,
    this.showControllerLabel = true,
    bool sendValueOnCreate = true,
  }) : super(key: key) {
    if (sendValueOnCreate) sendValue();
  }
  final MidiWidgetParameters parameters;

  /// The interface that will be used to send MIDI CC messages.
  final MidiInterface interface;

  /// Indicates if the controller number assignment should be displayed.
  final bool showControllerLabel;

  /// Indicates if the channel number assignment should be displayed.
  final bool showChannelLabel;

  final Function(MidiWidgetParameters parameters)? onChanged;

  Widget renderControl(BuildContext context, int value, int min, int max);

  /// Copies the parameters of this widget with the exception
  /// of the [value] field set to [newValue].
  MidiWidgetParameters copyParametersWithNewValue(int newValue) {
    return MidiWidgetParameters.create(
      channel: parameters.channel,
      controller: parameters.controller,
      targetDevice: parameters.targetDevice,
      value: newValue,
      max: parameters.max,
      min: parameters.min,
      title: parameters.title,
    );
  }

  late final int _min = parameters.min;
  late final int _max = parameters.max;

  /// Send a MIDI CC message to the remote host
  /// with the [parameters] provided.
  void sendValue() => parameters.sendWithInterface(interface);

  Widget _buildLabel(BuildContext context, String text) {
    return Opacity(
      opacity: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Clamp the value to ensure it does not go
    /// over the min and max values.
    final value = parameters.value.clamp(_min, _max);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(parameters.title),
          if (showControllerLabel)
            _buildLabel(
              context,
              "CTRL: ${parameters.controller.toString().padLeft(2, '0')}",
            ),
          renderControl(context, value, _min, _max),
          if (showChannelLabel)
            _buildLabel(
              context,
              "CHAN: ${parameters.channel.toString().padLeft(2, '0')}",
            ),
        ],
      ),
    );
  }
}

abstract class MidiWidgetParametersModel {
  /// The name of the target MIDI device that
  /// the widget will be sending CC commands to.
  String get targetDevice;

  /// The sets the target MIDI channel number of the widget.
  int get channel;

  /// The sets the target MIDI controller number of the widget.
  int get controller;

  /// Sets the CC value of the widget.
  int get value;

  /// Minimum CC value of the widget. Defaults to 0.
  int get min;

  /// Maximum CC value of the widget. Defaults to 127.
  int get max;

  /// An optional title for the widget to display
  /// when it is rendered.
  String get title;

  ControlChange toCC();

  void sendWithInterface(MidiInterface interface);
}

class MidiWidgetParameters extends Parseable
    implements MidiWidgetParametersModel {
  MidiWidgetParameters._();

  @override
  String toString() {
    return "Slider State Channel: $channel Controller: $controller Value: $value";
  }

  @override
  int get channel => this.get(Midi.kChannel);

  @override
  int get controller => this.get(Midi.kController);

  @override
  int get max => this.get(Midi.kMax);

  @override
  int get min => this.get(Midi.kMin);

  @override
  String get targetDevice => this.get("targetDevice");

  @override
  String get title => this.get("title");

  @override
  int get value => this.get(Midi.kValue);

  static MidiWidgetParameters create({
    required String title,
    required String targetDevice,
    required int channel,
    required int controller,
    required int value,
    int? min,
    int? max,
  }) {
    final params = MidiWidgetParameters._();
    params.set("targetDevice", targetDevice);
    params.set(Midi.kChannel, channel);
    params.set(Midi.kController, controller);
    params.set(Midi.kValue, value);
    params.set(Midi.kMin, min ?? Midi.kMinValue);
    params.set(Midi.kMax, max ?? Midi.kMaxValue);
    params.set("title", title);
    return params;
  }

  @override
  ControlChange toCC() => ControlChange(
        channel: channel,
        value: value,
        controller: controller,
      );

  @override
  void sendWithInterface(MidiInterface interface) {
    interface.sendMidiCC(targetDevice, toCC());
  }
}

class MidiWidgetParametersParser extends Parser<MidiWidgetParameters> {
  @protected
  @override
  MidiWidgetParameters createModel() => MidiWidgetParameters._();

  @override
  Map<String, Type?>? get typeMap {
    return {
      "targetDevice": String,
      Midi.kChannel: int,
      Midi.kController: int,
      Midi.kValue: int,
      Midi.kMin: int,
      Midi.kMax: int,
      "title": String,
    };
  }
}
