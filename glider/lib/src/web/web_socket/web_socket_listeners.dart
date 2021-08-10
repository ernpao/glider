import 'dart:convert';

import 'package:glider_models/glider_models.dart';

abstract class WebSocketListener {
  Function(dynamic data)? get onData;
  Function(Object? error)? get onError;
  Function()? get onDone;
}

class WebSocketJsonListener implements WebSocketListener {
  WebSocketJsonListener({
    this.onDataReceived,
    this.onError,
    this.onDone,
  });

  final Function(JSON json)? onDataReceived;
  final Function(Object? error)? onError;
  final Function()? onDone;

  @override
  Function(dynamic data)? get onData {
    return (data) {
      final JSON? json = _dataToJson(data);
      if (json != null) onDataReceived?.call(json);
    };
  }

  JSON? _dataToJson(data) {
    if (data == null) return null;
    final String jsonStr = data is String ? data : jsonEncode(data);
    final JSON json = JSON.parse(jsonStr);
    return json;
  }
}
