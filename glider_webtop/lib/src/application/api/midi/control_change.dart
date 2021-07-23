import 'midi_message.dart';

class ControlChange extends MidiMessage {
  final int value;
  final int controller;

  ControlChange({
    required int channel,
    required this.value,
    required this.controller,
  })  : assert(value >= 0 && value <= 127),
        assert(controller >= 0 && controller <= 127),
        super(channel: channel);
}

/// A MIDI Control Change (CC) message with
/// the [value] parameter set to 127
class ControlChangeMax extends ControlChange {
  ControlChangeMax({
    required int channel,
    required int controller,
  }) : super(channel: channel, value: 127, controller: controller);
}

/// A MIDI Control Change (CC) message with
/// the [value] parameter set to 0
class ControlChangeMin extends ControlChange {
  ControlChangeMin({
    required int channel,
    required int controller,
  }) : super(channel: channel, value: 0, controller: controller);
}
