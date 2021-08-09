import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_data.dart';
import 'ws_socket.dart';

/// An API that uses both HTTP requests and WebSocket connections.
class WsAPI extends WebAPI with UUID implements WsSocket {
  WsAPI({
    required String host,
    bool useHttps = true,
    bool useWss = true,
    int? httpPort,
    WebRequestHeaders? httpFixedHeaders,
    String? webSocketPath,
    int? webSocketPort,
  }) : super(
          host: host,
          useHttps: useHttps,
          useWss: useWss,
          httpPort: httpPort,
          httpFixedHeaders: httpFixedHeaders,
          webSocketPath: webSocketPath,
          webSocketPort: webSocketPort,
        );

  @override
  @protected
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) {
    socket.sendWsJson(body, type: type, topic: topic, category: category);
  }

  @override
  @protected
  void sendWs(data, {String? type, String? category, String? topic}) {
    socket.sendWs(data, type: type, category: category, topic: topic);
  }

  @override
  @protected
  void sendWsData(WsData data) {
    socket.sendWsData(data);
  }

  @override
  late final WsSocket socket = WsSocket(
    host: host,
    path: webSocketPath,
    port: webSocketPort,
    useWss: useWss,
  );
}
