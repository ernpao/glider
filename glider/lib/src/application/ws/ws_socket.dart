import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_data.dart';

abstract class WsDataSink {
  /// Send a WsData object with a string message body.
  void sendWs(String body, {String? type, String? category, String? topic});

  /// Send a WsData object with JSON body content.
  void sendWsJson(JSON body, {String? type, String? category, String? topic});

  /// Send [WsData].
  void sendWsData(WsData data);
}

class WsSocket extends WebSocket with UUID implements WsDataSink {
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
    this.sendWsData(wsMessage);
  }

  @override
  void sendWsJson(JSON body, {String? type, String? category, String? topic}) {
    this.sendWs(body.encode(), type: type, category: category, topic: topic);
  }

  @override
  void sendWsData(WsData data) {
    if (isClosed) {
      throw new Exception(
        "WsSocket should be open before calling sendWsData.",
      );
    }
    super.send(data.encode());
  }
}
