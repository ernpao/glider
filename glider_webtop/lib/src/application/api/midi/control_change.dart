class ControlChange {
  final int channel;
  final int value;
  final int controller;

  ControlChange({
    required this.channel,
    required this.value,
    required this.controller,
  });
}
