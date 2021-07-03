import 'package:flutter_with_serverless/data/src/data_layer.dart';

const int _webserver_port = 6767;
const int _websocket_port = 6868;
const String _host = "192.168.100.191";

class WebtopAPI {
  final WebSocket _webSocket = WebtopWebSocket();
  final WebAPI _webAPI = WebtopWebAPI();

  GET index() => _webAPI.index();

  void connectToWebSocket() {
    _webSocket.connect();
    _webSocket.send("Hello!");
  }
}

class WebtopWebSocket extends WebSocket {
  WebtopWebSocket() : super(host: _host, port: _websocket_port);
}

class WebtopWebAPI extends WebAPI {
  WebtopWebAPI()
      : super(
          host: _host,
          useHttps: false,
          defaultPort: _webserver_port,
        );
}
