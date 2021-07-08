import 'src/data_layer.dart';

abstract class WebtopAPI {}

class WebtopClient with WebHost implements WebtopAPI, WebHttpClient, WebSocket {
  late WebSocketClient _socket = WebSocketClient(host: host, port: socketPort);
  late WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: false,
  );

  final int port;
  final int socketPort;

  @override
  final String host;

  WebtopClient({
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
    bool? retryOnDone,
  }) =>
      _socket.openSocket(
        listener: listener,
        pingInterval: pingInterval,
        retryOnDone: retryOnDone,
      );

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
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;
}
