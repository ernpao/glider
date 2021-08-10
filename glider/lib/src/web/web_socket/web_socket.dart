import 'web_socket_interfaces.dart';
import 'web_socket_listeners.dart';

/// A [WebSocketConnection] that can used to listen to
/// incoming data with a [WebSocketListener].
class WebSocketStreamChannel extends WebSocketConnection
    with WebSocketStreamConnection {
  WebSocketStreamChannel({
    required String host,
    int? port,
    String? path,
    bool useWss = false,
  }) : super(
          host: host,
          path: path,
          port: port,
          useWss: useWss,
        );

  @override
  WebSocketConnection get connection => this;
}

/// A [WebSocketConnection] that can used to send data.
class WebSocketSinkChannel extends WebSocketConnection
    with WebSocketSinkConnection {
  WebSocketSinkChannel({
    required String host,
    int? port,
    String? path,
    bool useWss = false,
  }) : super(
          host: host,
          path: path,
          port: port,
          useWss: useWss,
        );

  @override
  WebSocketConnection get connection => this;
}

/// A [WebSocketConnection] that can used to listen to
/// incoming data as well as send data.
class WebSocket extends WebSocketConnection
    with WebSocketSinkConnection, WebSocketStreamConnection {
  WebSocket({
    required String host,
    int? port,
    String? path,
    bool useWss = false,
  }) : super(
          host: host,
          path: path,
          port: port,
          useWss: useWss,
        );

  @override
  WebSocketConnection get connection => this;
}
