import 'src/data_layer.dart';

abstract class KeynoteClientInterface {
  void moveMouse(int x, int y);
  void offsetMouse(int xOffset, int yOffset);
  void clickMouse(MouseClick click);
  void sendKeystroke(String keys, KeyboardModifier modifier);
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
    implements KeynoteClientInterface, WebClientInterface, WebSocketInterface {
  late WebSocket _socket = WebSocket(host: host, port: socketPort);
  late WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  final int port;
  final int socketPort;

  @override
  final String host;

  KeynoteClient({
    required this.host,
    required this.port,
    required this.socketPort,
  });

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket({WebSocketListener? listener, Duration? pingInterval}) =>
      _socket.openSocket(listener: listener, pingInterval: pingInterval);

  @override
  void send(WebSocketMessage message) => _socket.send(message);

  @override
  void sendJson(JSON data, {String? type, String? topic}) =>
      _socket.sendJson(data, type: type, topic: topic);

  /// Sends a ping type message to the WebSocket.
  void pingSocket() => _socket.send(WebSocketMessage(type: "ping"));

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> httpGET(String? path) => _client.httpGET(path);

  @override
  Future<WebResponse> httpPOST(String? path) => _client.httpPOST(path);

  @override
  void sendKeystroke(String key, KeyboardModifier modifier) {
    final data = JSON();
    data.set("key", key);
    data.set("modifier", enumToString(modifier));
    sendJson(data, topic: enumToString(_Topic.keyboard));
  }

  void _sendMouseCommand(dynamic data, _Type type) {
    send(WebSocketMessage(
      type: enumToString(type),
      topic: enumToString(_Topic.mouse),
      data: (data is Mappable) ? data.map() : data,
    ));
  }

  @override
  void moveMouse(int x, int y) {
    final data = JSON();
    data.set("x", x);
    data.set("y", y);
    _sendMouseCommand(data, _Type.move);
  }

  @override
  void clickMouse(MouseClick click) {
    _sendMouseCommand(enumToString(click), _Type.click);
  }

  @override
  void offsetMouse(int xOffset, int yOffset) {
    final data = JSON();
    data.set("x", xOffset);
    data.set("y", yOffset);
    _sendMouseCommand(data, _Type.offset);
  }

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;
}
