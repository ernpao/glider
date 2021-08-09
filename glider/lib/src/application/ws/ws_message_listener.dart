import 'package:glider_models/glider_models.dart';

import '../components/web/web.dart';
import 'ws_message.dart';

class WsMessageListener extends WebSocketJsonListener {
  WsMessageListener({
    required Function(WS_Message message) onMessage,
    this.onDone,
    this.onError,
  }) : super(
          onDataReceived: (json) {
            final message = _jsonToMessage(json);
            onMessage(message);
          },
          onDone: onDone,
          onError: onError,
        );

  final Function(Object? error)? onError;
  final Function()? onDone;

  static WS_Message _jsonToMessage(JSON json) {
    return WS_Message.fromJson(json);
  }
}
