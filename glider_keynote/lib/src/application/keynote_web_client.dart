import 'package:glider/glider.dart';
import 'package:glider_keynote/src/application/models/keynote_command.dart';

import 'keynote_interface.dart';
import 'models/models.dart';

class KeynoteWebClient
    with WebHost
    implements KeynoteInterface, WebInterface, WebSocketInterface {
  late final WebSocket _socket = WebSocket(host: host, port: socketPort);
  late final WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  final int port;
  final int socketPort;

  @override
  final String host;

  KeynoteWebClient({
    required this.host,
    required this.port,
    required this.socketPort,
  });

  @override
  Future<WebResponse> index() => _client.index();

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
  void sendJson(JSON data, {String? type, String? category, String? topic}) =>
      _socket.sendJson(data, type: type, category: category, topic: topic);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> get(String? path) => _client.get(path);

  @override
  Future<WebResponse> post(String? path) => _client.post(path);

  @override
  void sendKeystroke(String key, {KeyboardModifier? modifier}) {
    sendMessage(KeyboardKeystrokeCommand(
      sender: _socket.uuid,
      key: key,
    ));
  }

  @override
  void moveMouse(int x, int y) {
    sendMessage(KeynoteMouseMoveCommand(sender: _socket.uuid, x: x, y: y));
  }

  @override
  void clickMouse(MouseButton button) {
    sendMessage(KeynoteMouseClickCommand(
      sender: _socket.uuid,
      button: button,
    ));
  }

  @override
  void offsetMouse(int xOffset, int yOffset) {
    sendMessage(KeynoteMouseOffsetCommand(
      sender: _socket.uuid,
      xOffset: xOffset,
      yOffset: yOffset,
    ));
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

  @override
  void sendMessage(WebSocketMessage message) => _socket.sendMessage(message);

  @override
  void printMessage(String text) {
    final request = createGET("/keyboard")
      ..withParameter("keyType", "string")
      ..withParameter("key", text);
    request.send();
  }

  @override
  GET createGET(String? path) => _client.createGET(path);

  @override
  POST createPOST(String? path) => _client.createPOST(path);
}
