import 'package:flutter/widgets.dart';

import 'apis/apis.dart';

/// A widget that sends MIDI CC messages to the Webtop server.
class MidiContinousControlWidget extends StatelessWidget {
  const MidiContinousControlWidget({
    Key? key,
    required this.builder,
    required this.channel,
    required this.controller,
    required this.deviceName,
    required this.interface,
  }) : super(key: key);

  /// A builder function that provides the [BuildContext] and a [valueSetter]
  /// function that sends the CC message to the MIDI device with name [deviceName]
  /// containing the [value], [channel], and [controller]
  /// parameters.
  final Function(BuildContext context, Function(int value) valueSetter) builder;

  final int channel;
  final int controller;
  final MidiClient interface;
  final String deviceName;

  @override
  Widget build(BuildContext context) => builder(context, _sendMidiMessage);

  void _sendMidiMessage(int value) => interface.sendMidiCC(
        deviceName,
        ControlChange(channel: channel, value: value, controller: controller),
      );
}
