abstract class MidiMessage {
  MidiMessage({
    required this.channel,
  }) : assert(channel >= 0 && channel <= 15);
  final int channel;
}

abstract class MidiNoteMessage extends MidiMessage {
  MidiNoteMessage({
    required this.note,
    required this.velocity,
    required int channel,
    required String type,
  })  : assert(velocity >= 0 && velocity <= 127),
        assert(note >= 0 && note <= 127),
        super(channel: channel);

  final int velocity;
  final int note;
}
