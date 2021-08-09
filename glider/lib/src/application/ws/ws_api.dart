import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_data.dart';
import 'ws_socket.dart';

/// An API that uses both HTTP requests and WebSocket connections.
class WsAPI with WebURI implements WebInterface, WsSocket {
  WsAPI({
    required this.host,
    this.useHttpsForWebClient = true,
    required this.port,
    this.webSocketPort,
    this.fixedWebClientHeaders,
    this.useWssForWebSocket = true,
    this.path,
  });

  /// Determines if the `webClient` used by this API
  /// uses HTTPS.
  final bool useHttpsForWebClient;

  /// Scheme component of the URI of the `webClient` used by the API.
  @override
  String get scheme => webClient.scheme;

  @override
  final String host;

  @override
  final int port;

  /// A set of headers that will be sent with all
  /// the requests made by this [WebInterface].
  final WebRequestHeaders? fixedWebClientHeaders;

  late final WebClient _client = WebClient(
    host: host,
    defaultPort: port,
    useHttps: useHttpsForWebClient,
    fixedHeaders: fixedWebClientHeaders,
  );

  final bool useWssForWebSocket;

  /// The port component of the URI that this
  /// API's `webSocket` will connect to.
  final int? webSocketPort;

  /// The `webClient` used by this API.
  @protected
  WebClient get webClient => _client;

  /// The path component of the URI of the [WebSocket]
  /// used by this API.
  @override
  @protected
  final String? path;

  late final WsSocket _socket = WsSocket(
    host: host,
    port: webSocketPort,
    useWss: useWssForWebSocket,
    path: path,
  );

  /// The `webSocket` used by this API.
  @protected
  WsSocket get webSocket => _socket;

  @override
  Future<WebResponse> index() => _client.index();

  @override
  void openSocket() => _socket.openSocket();

  @override
  @protected
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) =>
      _socket.sendWsJson(body, type: type, topic: topic, category: category);

  @override
  void closeSocket() => _socket.closeSocket();

  @override
  @protected
  Future<WebResponse> get(String? requestPath) => _client.get(path);

  @override
  @protected
  Future<WebResponse> post(String? requestPath) => _client.post(path);

  @override
  bool get hasListener => _socket.hasListener;

  @override
  bool get hasNoListener => _socket.hasNoListener;

  @override
  @protected
  void sendWs(data, {String? type, String? category, String? topic}) =>
      _socket.sendWs(data, type: type, category: category, topic: topic);

  @override
  bool get isClosed => _socket.isClosed;

  @override
  bool get isOpen => _socket.isOpen;

  @override
  @protected
  void sendWsData(WsData data) => _socket.sendWsData(data);

  @override
  @protected
  GET createGET(String? requestPath) => _client.createGET(requestPath);

  @override
  @protected
  POST createPOST(String? requestPath) => _client.createPOST(requestPath);

  @override
  @protected
  DELETE createDELETE(String? requestPath) => _client.createDELETE(requestPath);

  @override
  @protected
  PUT createPUT(String? requestPath) => _client.createPUT(requestPath);

  @override
  @protected
  PATCH createPATCH(String? requestPath) => _client.createPATCH(requestPath);

  @override
  @protected
  T createRequest<T extends WebRequest>(String? requestPath) =>
      _client.createRequest<T>(requestPath);

  @override
  void listen(WebSocketListener listener, {bool reopenOnDone = true}) {
    _socket.listen(listener, reopenOnDone: reopenOnDone);
  }

  @override
  @protected
  WebSocketListener? get listener => _socket.listener;

  @override
  @protected
  bool get reopenOnDone => _socket.reopenOnDone;

  @override
  @protected
  bool get useWss => _socket.useWss;

  @override
  @protected
  WebSocketChannel? get channel => _socket.channel;

  @override
  @protected
  String get uuid => _socket.uuid;

  @override
  @protected
  WebSocketConnection get connection => _socket.connection;

  @override
  @protected
  void send(String data) => _socket.send(data);

  @override
  @protected
  void sendJson(JSON json) => _socket.sendJson(json);
}
