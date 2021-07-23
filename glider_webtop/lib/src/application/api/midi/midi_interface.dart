import 'control_change.dart';

abstract class MidiInterface {
  void sendMidiCC(String deviceName, ControlChange message);
}
