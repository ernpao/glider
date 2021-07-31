import 'midi_message.dart';

class ControlChange extends MidiMessage {
  final int value;
  final int controller;

  ControlChange({
    required int channel,
    required this.value,
    required this.controller,
  })  : assert(Midi.verifyValue(value)),
        assert(Midi.verifyChannel(channel)),
        super(channel: channel);
}

/// A MIDI Control Change (CC) message with
/// the [value] parameter set to 127
class ControlChangeMax extends ControlChange {
  ControlChangeMax({
    required int channel,
    required int controller,
  }) : super(channel: channel, value: Midi.kMaxChannel, controller: controller);
}

/// A MIDI Control Change (CC) message with
/// the [value] parameter set to 0
class ControlChangeMin extends ControlChange {
  ControlChangeMin({
    required int channel,
    required int controller,
  }) : super(channel: channel, value: Midi.kMinValue, controller: controller);
}
