import 'package:glider/glider.dart';

import 'webtop_interface.dart';

class WebtopWebAPI
    with WebURI
    implements WebtopInterface, WebInterface, WS_Socket {
  WebtopWebAPI({
    required this.host,
    required this.port,
    required this.socketPort,
  });

  late final WS_Socket _socket = WS_Socket(
    host: host,
    port: socketPort,
  );

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

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket() => _socket.openSocket();

  @override
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) =>
      _socket.sendWsJson(body, type: type, topic: topic, category: category);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  Future<WebResponse> get(String? requestPath) => _client.get(path);

  @override
  Future<WebResponse> post(String? requestPath) => _client.post(path);

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;

  @override
  void sendWs(data, {String? type, String? category, String? topic}) =>
      _socket.sendWs(data, type: type, category: category, topic: topic);

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;

  @override
  void sendWsMessage(WS_Message message) => _socket.sendWsMessage(message);

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
  void listen(WebSocketListener listener, {bool reopenOnDone = true}) {
    _socket.listen(listener, reopenOnDone: reopenOnDone);
  }

  @override
  WebSocketListener? get listener => _socket.listener;

  @override
  bool get reopenOnDone => _socket.reopenOnDone;

  @override
  bool get useWss => _socket.useWss;

  @override
  WebSocketChannel? get channel => _socket.channel;

  @override
  String get uuid => _socket.uuid;

  @override
  WebSocketConnection get connection => _socket.connection;

  @override
  void send(String data) => _socket.send(data);

  @override
  void sendJson(JSON json) => _socket.sendJson(json);
}
