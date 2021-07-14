import 'package:glider/glider.dart';

abstract class WebtopAPI {}

class WebtopClient
    with WebHost
    implements WebtopAPI, WebHttpClient, WebSocketClient {
  WebtopClient({
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
    Duration? pingInterval,
    bool reopenOnDone = true,
  }) =>
      _socket.openSocket(
        eventHandler: eventHandler,
        pingInterval: pingInterval,
        reopenOnDone: reopenOnDone,
      );

  @override
  void sendJson(JSON data, {String? type, String? topic}) =>
      _socket.sendJson(data, type: type, topic: topic);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> httpGET(String? path) => _client.httpGET(path);

  @override
  Future<WebResponse> httpPOST(String? path) => _client.httpPOST(path);

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;

  @override
  void send(data, {String? category, String? type, String? topic}) =>
      _socket.send(data, type: type, category: category, topic: topic);

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;
}
