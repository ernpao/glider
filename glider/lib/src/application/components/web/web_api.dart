import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_http/web_client.dart';
import 'web_http/web_request.dart';
import 'web_http/web_response.dart';
import 'web_mixins.dart';
import 'web_socket/web_socket.dart';
import 'web_socket/web_socket_interfaces.dart';
import 'web_socket/web_socket_listeners.dart';
import 'web_typedefs.dart';

/// An API that uses both HTTP requests and WebSocket connections
/// as interfaces.
class WebAPI with WebURI implements WebClient, WebSocket {
  WebAPI({
    required this.host,
    this.useHttps = true,
    this.useWss = true,
    this.httpPort,
    this.httpFixedHeaders,
    this.webSocketPath,
    this.webSocketPort,
  });

  /// Determines if the `webClient` used by this API
  /// uses HTTPS.
  final bool useHttps;

  /// Scheme component of the URI of the `webClient` used by the API.
  @override
  String get scheme => webClient.scheme;

  @override
  final String host;

  /// Port component of the URI of the `webClient` used by the API.
  @override
  int? get port => webClient.defaultPort;

  /// Port component of the URI of the `webClient` used by the API.
  final int? httpPort;

  /// A set of headers that will be sent with all
  /// the requests made by the [WebClient] used
  /// by this API.
  final WebRequestHeaders? httpFixedHeaders;

  late final WebClient _webClient = WebClient(
    host: host,
    defaultPort: httpPort,
    useHttps: useHttps,
    fixedHeaders: httpFixedHeaders,
  );

  /// The [WebClient] used by this API to make
  /// HTTP requests.
  @protected
  WebClient get webClient => _webClient;

  @override
  final bool useWss;

  /// The port component of the URI that this
  /// API's `webSocket` will connect to.
  final int? webSocketPort;

  /// The path component of the URI of the [WebSocket]
  /// used by this API.
  final String? webSocketPath;

  /// The path component of the URI of the [WebSocket]
  /// used by this API.
  @override
  @protected
  String? get path => socket.path;

  /// The `webSocket` used by this API.
  @protected
  late final WebSocket socket = WebSocket(
    host: host,
    port: webSocketPort,
    useWss: useWss,
    path: webSocketPath,
  );

  @override
  Future<WebResponse> index() => _webClient.index();

  @override
  void openSocket() => socket.openSocket();

  @override
  void closeSocket() => socket.closeSocket();

  @override
  @protected
  Future<WebResponse> get(String? requestPath) => _webClient.get(path);

  @override
  @protected
  Future<WebResponse> post(String? requestPath) => _webClient.post(path);

  @override
  bool get hasListener => socket.hasListener;

  @override
  bool get hasNoListener => socket.hasNoListener;

  @override
  bool get isClosed => socket.isClosed;

  @override
  bool get isOpen => socket.isOpen;

  @override
  @protected
  GET createGET(String? requestPath) => _webClient.createGET(requestPath);

  @override
  @protected
  POST createPOST(String? requestPath) => _webClient.createPOST(requestPath);

  @override
  @protected
  DELETE createDELETE(String? requestPath) =>
      _webClient.createDELETE(requestPath);

  @override
  @protected
  PUT createPUT(String? requestPath) => _webClient.createPUT(requestPath);

  @override
  @protected
  PATCH createPATCH(String? requestPath) => _webClient.createPATCH(requestPath);

  @override
  @protected
  T createRequest<T extends WebRequest>(String? requestPath) =>
      _webClient.createRequest<T>(requestPath);

  @override
  void listen(WebSocketListener listener, {bool reopenOnDone = true}) {
    socket.listen(listener, reopenOnDone: reopenOnDone);
  }

  @override
  @protected
  WebSocketListener? get listener => socket.listener;

  @override
  @protected
  bool get reopenOnDone => socket.reopenOnDone;

  @override
  @protected
  WebSocketChannel? get channel => socket.channel;

  @override
  @protected
  WebSocketConnection get connection => socket.connection;

  @override
  @protected
  void send(String data) => socket.send(data);

  @override
  @protected
  void sendJson(JSON json) => socket.sendJson(json);

  @override
  int? get defaultPort => _webClient.defaultPort;

  @override
  WebRequestHeaders? get fixedHeaders => _webClient.fixedHeaders;
}
