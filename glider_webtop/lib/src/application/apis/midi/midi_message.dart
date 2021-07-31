class Midi {
  Midi._();

  static bool _verifyValue(String property, int value) {
    return (_getMin(property) <= value) && (value <= _getMax(property));
  }

  static bool verifyChannel(int i) => _verifyValue(kChannel, i);
  static bool verifyValue(int i) => _verifyValue(kValue, i);
  static bool verifyController(int i) => _verifyValue(kController, i);
  static bool verifyVelocity(int i) => _verifyValue(kVelocity, i);
  static bool verifyNote(int i) => _verifyValue(kNote, i);

  static final int kMinChannel = _getMin(kChannel);
  static final int kMaxChannel = _getMax(kChannel);

  static final int kMinValue = _getMin(kValue);
  static final int kMaxValue = _getMax(kValue);

  static final int kMinController = _getMin(kController);
  static final int kMaxController = _getMax(kController);

  static final int kMinVelocity = _getMin(kVelocity);
  static final int kMaxVelocity = _getMax(kVelocity);

  static final int kMinNote = _getMin(kNote);
  static final int kMaxNote = _getMax(kNote);

  static int _getMin(String key) => minMaxValues[key]![_min]!;
  static int _getMax(String key) => minMaxValues[key]![_max]!;

  static const String _min = "min";
  static const String _max = "max";

  static const String kChannel = "channel";
  static const String kValue = "value";
  static const String kController = "controller";
  static const String kVelocity = "velocity";
  static const String kNote = "note";

  static const Map<String, Map<String, int>> minMaxValues = {
    kChannel: {_min: 0, _max: 15},
    kValue: {_min: 0, _max: 127},
    kController: {_min: 0, _max: 127},
    kVelocity: {_min: 0, _max: 127},
    kNote: {_min: 0, _max: 127}
  };
}

abstract class MidiMessage {
  MidiMessage({
    required this.channel,
  }) : assert(Midi.verifyChannel(channel));
  final int channel;
}

abstract class MidiNoteMessage extends MidiMessage {
  MidiNoteMessage({
    required this.note,
    required this.velocity,
    required int channel,
    required String type,
  })  : assert(Midi.verifyVelocity(velocity)),
        assert(Midi.verifyNote(note)),
        super(channel: channel);

  final int velocity;
  final int note;
}
