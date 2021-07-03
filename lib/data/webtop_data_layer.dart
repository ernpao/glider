import 'src/data_layer.dart';

const int _webserver_port = 6767;
const int _websocket_port = 6868;
const String _host = "192.168.100.191";

class WebtopClient {
  final WebtopSocket _socket = WebtopSocket();
  final WebtopWebClient _client = WebtopWebClient();

  GET index() => _client.index();

  void connectToSocket({
    required WebSocketListener listener,
    Duration? pingInterval,
  }) =>
      _socket.connect(listener: listener, pingInterval: pingInterval);

  /// Send data to the web socket.
  void sendToSocket(WebSocketMessage message) => _socket.sendMessage(message);

  /// Send JSON data to the web socket.
  void sendJsonToSocket(JSON data, {String? type, String? topic}) =>
      _socket.sendJSON(data, type: type, topic: topic);

  /// Sends a ping type message to the web socket.
  void pingSocket() => _socket.sendMessage(WebSocketMessage(type: "ping"));

  /// Closes the web socket connection.
  void closeSocketConnection() => _socket.closeConnection();
}

class WebtopSocket extends WebSocket {
  WebtopSocket() : super(host: _host, port: _websocket_port);
}

class WebtopWebClient extends WebClient {
  WebtopWebClient()
      : super(
          host: _host,
          useHttps: false,
          defaultPort: _webserver_port,
        );
}
