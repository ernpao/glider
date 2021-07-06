import 'src/data_layer.dart';

const int _web_port = 6767;
const int _socket_port = 6868;

abstract class WebtopClientInterface {}

class WebtopClient
    with WebHost
    implements WebtopClientInterface, WebClientInterface, WebSocketInterface {
  late WebSocket _socket = WebSocket(host: host, port: _socket_port);
  late WebClient _client = WebClient(
    host: host,
    defaultPort: _web_port,
    useHttps: false,
  );

  @override
  final String host;

  WebtopClient({
    required this.host,
  });

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket(
          {required WebSocketListener listener, Duration? pingInterval}) =>
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
}
