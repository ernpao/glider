import 'package:glider_webtop/glider_webtop.dart';
import 'package:glider_webtop/src/application/api/midi/control_change.dart';
import 'package:glider_webtop/src/application/api/midi/midi_interface.dart';

class WebtopMidiClient
    with WebHost
    implements MidiInterface, WebSocketManagement {
  @override
  final String host;

  WebtopMidiClient({
    required this.host,
    required this.socketPort,
  });

  final int socketPort;

  late final WebSocket _socket = WebSocket(host: host, port: socketPort);

  @override
  void sendMidiCC(String deviceName, ControlChange message) {
    final body = JSON();
    body.set("name", deviceName);
    body.set("controller", message.controller);
    body.set("value", message.value);
    body.set("channel", message.channel);
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
