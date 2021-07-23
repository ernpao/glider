import 'package:glider_webtop/src/application/api/midi/control_change.dart';

abstract class MidiInterface {
  void sendCC(String deviceName, ControlChange parameter);
}
