import 'src/data_layer.dart';

const int _web_port = 6767;
const int _socket_port = 6868;
const String _host = "192.168.100.191";

class WebtopClient implements WebClientInterface, WebSocketInterface {
  final WebSocket _socket = WebSocket(host: _host, port: _socket_port);
  final WebClient _client = WebClient(host: _host, defaultPort: _web_port);

  @override
  GET index() => _client.index();

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
  GET httpGET(String? path) => _client.httpGET(path);

  @override
  POST httpPOST(String? path) => _client.httpPOST(path);
}
