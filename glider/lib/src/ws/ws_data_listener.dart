import 'package:glider_models/glider_models.dart';

import '../web/web.dart';
import 'ws_data.dart';

class WsDataListener extends WebSocketJsonListener {
  WsDataListener({
    required Function(WsData message) onMessage,
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

  static WsData _jsonToMessage(JSON json) {
    return WsData.fromJson(json);
  }
}
