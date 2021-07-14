import 'package:glider/glider.dart';

abstract class KeynoteAPI {
  void moveMouse(int x, int y);
  void offsetMouse(int xOffset, int yOffset);
  void clickMouse(MouseClick click);
  void sendKeystroke(String keys, {KeyboardModifier? modifier});
}

enum _Topic {
  mouse,
  keyboard,
}

enum _Type {
  click,
  move,
  offset,
}

enum MouseClick { left, right }

enum KeyboardModifier { alt, control, shift }

class KeynoteClient
    with WebHost, EnumToString
    implements KeynoteAPI, WebHttpClient, WebSocketClient {
  late final WebSocket _socket = WebSocket(host: host, port: socketPort);
  late final WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  final String name;
  final int port;
  final int socketPort;

  @override
  final String host;

  KeynoteClient({
    required this.name,
    required this.host,
    required this.port,
    required this.socketPort,
  });

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket({
    WebSocketEventHandler? eventHandler,
    Duration? pingInterval,
    bool reopenOnDone = true,
  }) =>
      _socket.openSocket(
        eventHandler: eventHandler,
        pingInterval: pingInterval,
        reopenOnDone: reopenOnDone,
      );

  @override
  void sendJson(JSON data, {String? type, String? category, String? topic}) =>
      _socket.sendJson(data, type: type, category: category, topic: topic);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> httpGET(String? path) => _client.httpGET(path);

  @override
  Future<WebResponse> httpPOST(String? path) => _client.httpPOST(path);

  @override
  void sendKeystroke(String key, {KeyboardModifier? modifier}) {
    final data = JSON();
    data.set("key", key);
    data.set("modifier", modifier != null ? enumToString(modifier) : null);
    sendJson(data, topic: enumToString(_Topic.keyboard));
  }

  void _sendMouseCommand(String command, _Type type) {
    send(command, type: enumToString(type), topic: enumToString(_Topic.mouse));
  }

  @override
  void moveMouse(int x, int y) {
    final command = JSON();
    command.set("x", x);
    command.set("y", y);
    _sendMouseCommand(command.stringify(), _Type.move);
  }

  @override
  void clickMouse(MouseClick click) {
    _sendMouseCommand(enumToString(click), _Type.click);
  }

  @override
  void offsetMouse(int xOffset, int yOffset) {
    final command = JSON();
    command.set("x", xOffset);
    command.set("y", yOffset);
    _sendMouseCommand(command.stringify(), _Type.offset);
  }

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;

  @override
  void send(String data, {String? type, String? category, String? topic}) {
    _socket.send(data, type: type, category: category, topic: topic);
  }

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;
}
