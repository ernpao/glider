class Midi {
  Midi._();

  static bool verifyProperty(String property, int value) =>
      (getMin(property) <= value) && (value <= getMax(property));

  static int _getMinOrMax(String property, String minMaxKey) {
    final validProperties = minMaxValues.keys;
    if (!validProperties.contains(property)) {
      throw Exception(
        "Cannot verify '$property' since it is not a valid MIDI property."
        "'property' must be one of the following: ${validProperties.join(",")}",
      );
    }
    return minMaxValues[property]![minMaxKey]!;
  }

  static bool verifyChannel(int i) => verifyProperty(kChannel, i);
  static bool verifyValue(int i) => verifyProperty(kValue, i);
  static bool verifyController(int i) => verifyProperty(kController, i);
  static bool verifyVelocity(int i) => verifyProperty(kVelocity, i);
  static bool verifyNote(int i) => verifyProperty(kNote, i);

  static final int kMinChannel = getMin(kChannel);
  static final int kMaxChannel = getMax(kChannel);

  static final int kMinValue = getMin(kValue);
  static final int kMaxValue = getMax(kValue);

  static final int kMinController = getMin(kController);
  static final int kMaxController = getMax(kController);

  static final int kMinVelocity = getMin(kVelocity);
  static final int kMaxVelocity = getMax(kVelocity);

  static final int kMinNote = getMin(kNote);
  static final int kMaxNote = getMax(kNote);

  static int getMin(String key) => _getMinOrMax(key, _min);
  static int getMax(String key) => _getMinOrMax(key, _max);

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
