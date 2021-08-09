import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_data.dart';

abstract class WsDataSinkChannel {
  /// Function for sending string content to the WebSocket server.
  void sendWs(String body, {String? type, String? category, String? topic});

  /// Send JSON data to the WebSocket server. Essentially the same as sending
  /// the stringified JSON data using `send`.
  void sendWsJson(JSON body, {String? type, String? category, String? topic});

  /// Send a [WsData] to the server.
  void sendWsData(WsData data);
}

class WsSocket extends WebSocket with UUID implements WsDataSinkChannel {
  WsSocket({
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
  void sendWs(String body, {String? type, String? category, String? topic}) {
    final wsMessage = WsData(
      sender: uuid,
      category: category,
      type: type,
      topic: topic,
      body: body,
    );
    sendWsData(wsMessage);
  }

  @override
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) {
    sendWs(body.encode(), type: type, category: category, topic: topic);
  }

  @override
  void sendWsData(WsData data) {
    if (isClosed) {
      throw new Exception(
        "WsSocket should be open before calling sendWsData.",
      );
    }
    send(data.encode());
  }
}
