import 'package:glider/glider.dart';
import 'control_change.dart';
import 'midi_interface.dart';

class MidiWebAPI extends WsAPI implements MidiInterface {
  MidiWebAPI({
    required String host,
    required int socketPort,
  }) : super(
          host: host,
          useHttps: false,
          useWss: false,
          webSocketPort: socketPort,
        );

  @override
  void sendMidiCC(String deviceName, ControlChange message) {
    final body = JSON();
    body.setProperty("name", deviceName);
    body.setProperty("controller", message.controller);
    body.setProperty("value", message.value);
    body.setProperty("channel", message.channel);
    socket.sendWsJson(body, type: "midi", category: "cc");
  }
}
