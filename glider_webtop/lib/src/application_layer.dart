import 'package:glider/glider.dart';

abstract class WebtopAPI {}

class WebtopClient with WebHost implements WebtopAPI, WebHttpClient, WebSocket {
  final String name;

  late final WebSocketClient _socket = WebSocketClient(
    name: name,
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

  WebtopClient({
    required this.name,
    required this.host,
    required this.port,
    required this.socketPort,
  });

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket({
    WebSocketListener? listener,
    Duration? pingInterval,
    bool reconnectOnDone = true,
  }) =>
      _socket.openSocket(
        listener: listener,
        pingInterval: pingInterval,
        reconnectOnDone: reconnectOnDone,
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
}
