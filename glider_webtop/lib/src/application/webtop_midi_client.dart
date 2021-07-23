import 'package:glider_webtop/glider_webtop.dart';
import 'package:glider_webtop/src/application/api/midi/control_change.dart';
import 'package:glider_webtop/src/application/api/midi/midi_interface.dart';

class WebtopMidiClient
    with WebHost
    implements MidiInterface, WebSocketInterface {
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
  void sendJson(JSON body, {String? type, String? category, String? topic}) =>
      _socket.sendJson(body, type: type, topic: topic, category: category);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;

  @override
  void send(data, {String? type, String? category, String? topic}) =>
      _socket.send(data, type: type, category: category, topic: topic);

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;

  @override
  void sendWebSocketMessage(WebSocketMessage message) =>
      _socket.sendWebSocketMessage(message);
}
