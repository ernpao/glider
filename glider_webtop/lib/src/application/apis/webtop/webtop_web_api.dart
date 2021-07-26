import 'package:glider/glider.dart';

import 'webtop_interface.dart';

class WebtopWebAPI
    with WebHost
    implements WebtopInterface, WebInterface, WebSocketInterface {
  WebtopWebAPI({
    required this.host,
    required this.port,
    required this.socketPort,
  });

  late final WebSocket _socket = WebSocket(
    host: host,
    port: socketPort,
  );

  late final WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  final int port;
  final int socketPort;

  @override
  final String host;

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
  void sendJson(JSON body, {String? type, String? category, String? topic}) =>
      _socket.sendJson(body, type: type, topic: topic, category: category);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> get(String? path) => _client.get(path);

  @override
  Future<WebResponse> post(String? path) => _client.post(path);

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
  void sendMessage(WebSocketMessage message) => _socket.sendMessage(message);

  @override
  GET createGET(String? path) => _client.createGET(path);

  @override
  POST createPOST(String? path) => _client.createPOST(path);
}
