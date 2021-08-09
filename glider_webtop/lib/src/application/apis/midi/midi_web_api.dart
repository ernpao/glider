import 'package:glider_webtop/glider_webtop.dart';
import 'control_change.dart';
import 'midi_interface.dart';

class MidiWebAPI
    with WebURI
    implements MidiInterface, WebSocketConnection, WS_MessageSinkChannel {
  @override
  final String host;

  MidiWebAPI({
    required this.host,
    required this.socketPort,
  });

  final int socketPort;

  late final WS_Socket _socket = WS_Socket(host: host, port: socketPort);

  @override
  void sendMidiCC(String deviceName, ControlChange message) {
    final body = JSON();
    body.setProperty("name", deviceName);
    body.setProperty("controller", message.controller);
    body.setProperty("value", message.value);
    body.setProperty("channel", message.channel);
    _socket.sendWsJson(body, type: "midi", category: "cc");
  }

  @override
  void openSocket() => _socket.openSocket();

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  String? get path => null;

  @override
  String get scheme => wsScheme;

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;
  @override
  void sendWs(String body, {String? type, String? category, String? topic}) {
    _socket.sendWs(body, type: type, category: category, topic: topic);
  }

  @override
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) {
    _socket.sendWsJson(body, type: type, category: category, topic: topic);
  }

  @override
  void sendWsMessage(WS_Message message) {
    _socket.sendWsMessage(message);
  }

  @override
  WebSocketChannel? get channel => _socket.channel;

  @override
  bool get useWss => _socket.useWss;
}
