import 'src/data_layer.dart';

const int _web_port = 6767;
const int _socket_port = 6868;
const String _host = "192.168.100.191";

abstract class WebtopClientInterface {}

class WebtopClient
    implements WebtopClientInterface, WebClientInterface, WebSocketInterface {
  final WebSocket _socket = WebSocket(host: _host, port: _socket_port);
  final WebClient _client = WebClient(
    host: _host,
    defaultPort: _web_port,
    useHttps: false,
  );

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
