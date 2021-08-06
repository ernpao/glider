import 'package:glider_webtop/glider_webtop.dart';
import 'control_change.dart';
import 'midi_interface.dart';

class MidiWebAPI with WebHost implements MidiInterface, WebSocketManager {
  @override
  final String host;

  MidiWebAPI({
    required this.host,
    required this.socketPort,
  });

  final int socketPort;

  late final WebSocket _socket = WebSocket(host: host, port: socketPort);

  @override
  void sendMidiCC(String deviceName, ControlChange message) {
    final body = JSON();
    body.setProperty("name", deviceName);
    body.setProperty("controller", message.controller);
    body.setProperty("value", message.value);
    body.setProperty("channel", message.channel);
    _socket.sendJson(body, type: "midi", category: "cc");
  }

  @override
  void openSocket({
    WebSocketEventHandler? eventHandler,
    bool reopenOnDone = true,
  }) =>
      _socket.openSocket(
        eventHandler: eventHandler,
        reopenOnDone: reopenOnDone,
      );

  @override
  void closeSocket() => _socket.closeSocket();
}
