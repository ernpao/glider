import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_message.dart';

abstract class WS_MessageSinkChannel {
  /// Function for sending string content to the WebSocket server.
  void sendWs(String body, {String? type, String? category, String? topic});

  /// Send JSON data to the WebSocket server. Essentially the same as sending
  /// the stringified JSON data using `send`.
  void sendWsJson(JSON body, {String? type, String? category, String? topic});

  /// Send a [WS_Message] to the server.
  void sendWsMessage(WS_Message message);
}

class WS_Socket extends WebSocket with UUID implements WS_MessageSinkChannel {
  WS_Socket({
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
    final wsMessage = WS_Message(
      sender: uuid,
      category: category,
      type: type,
      topic: topic,
      body: body,
    );
    sendWsMessage(wsMessage);
  }

  @override
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) {
    sendWs(body.encode(), type: type, category: category, topic: topic);
  }

  @override
  void sendWsMessage(WS_Message message) {
    if (isClosed) {
      throw new Exception(
        "WS_Socket should be open before calling sendWsMessage.",
      );
    }
    send(message.encode());
  }
}
