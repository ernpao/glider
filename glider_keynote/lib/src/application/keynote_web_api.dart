import 'package:glider/glider.dart';

import 'keynote_interface.dart';
import 'models/models.dart';

class KeynoteWebAPI
    with WebURI
    implements
        KeynoteInterface,
        WebInterface,
        WS_MessageSinkChannel,
        WebSocketConnection {
  late final WS_Socket _socket = WS_Socket(host: host, port: socketPort);
  late final WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  @override
  final int port;
  final int socketPort;

  @override
  final String host;

  KeynoteWebAPI({
    required this.host,
    required this.port,
    required this.socketPort,
  });

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket() {
    _socket.openSocket();
  }

  @override
  void sendWsJson(JSON data, {String? type, String? category, String? topic}) =>
      _socket.sendWsJson(data, type: type, category: category, topic: topic);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> get(String? requestPath) => _client.get(requestPath);

  @override
  Future<WebResponse> post(String? requestPath) => _client.post(requestPath);

  @override
  void sendKeystroke(String key, {KeyboardModifier? modifier}) {
    sendWsMessage(KeyboardKeystrokeCommand(
      sender: _socket.uuid,
      key: key,
    ));
  }

  @override
  void moveMouse(int x, int y) {
    sendWsMessage(KeynoteMouseMoveCommand(sender: _socket.uuid, x: x, y: y));
  }

  @override
  void clickMouse(MouseButton button) {
    sendWsMessage(KeynoteMouseClickCommand(
      sender: _socket.uuid,
      button: button,
    ));
  }

  @override
  void offsetMouse(int xOffset, int yOffset) {
    sendWsMessage(KeynoteMouseOffsetCommand(
      sender: _socket.uuid,
      xOffset: xOffset,
      yOffset: yOffset,
    ));
  }

  @override
  void sendWs(String body, {String? type, String? category, String? topic}) {
    _socket.sendWs(body, type: type, category: category, topic: topic);
  }

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;

  @override
  void sendWsMessage(WS_Message message) => _socket.sendWsMessage(message);

  @override
  void printMessage(String text) {
    final request = createGET("/keyboard")
      ..withParameter("keyType", "string")
      ..withParameter("key", text);
    request.send();
  }

  @override
  GET createGET(String? requestPath) => _client.createGET(requestPath);

  @override
  POST createPOST(String? requestPath) => _client.createPOST(requestPath);

  @override
  DELETE createDELETE(String? requestPath) => _client.createDELETE(requestPath);

  @override
  PUT createPUT(String? requestPath) => _client.createPUT(requestPath);

  @override
  PATCH createPATCH(String? requestPath) => _client.createPATCH(requestPath);

  @override
  T createRequest<T extends WebRequest>(String? requestPath) =>
      _client.createRequest<T>(requestPath);

  @override
  String? get path => null;

  @override
  String get scheme => httpScheme;

  @override
  WebSocketChannel? get channel => _socket.channel;

  @override
  bool get useWss => _socket.useWss;
}
