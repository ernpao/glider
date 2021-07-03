import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/models.dart';
import 'mixins.dart';

abstract class WebSocket with WebHost {
  final String host;
  final int port;

  WebSocket({required this.host, required this.port});

  IOWebSocketChannel? _channel;
  Stream? get stream => _channel?.stream;
  WebSocketSink? get sink => _channel?.sink;

  void connect({
    required WebSocketListener listener,
    Duration? pingInterval,
  }) {
    _channel = IOWebSocketChannel.connect(
      'ws://$host:$port',
      pingInterval: pingInterval,
    );

    _channel?.stream.listen(
      (d) => listener.onMessage?.call(_convertStreamData(d)),
      onError: listener.onError,
      onDone: listener.onDone,
    );
  }

  void closeConnection() => _channel?.sink.close(status.goingAway);

  WebSocketMessage _convertStreamData(d) {
    final String jsonString = d is String ? d : jsonEncode(d);
    final JSON json = JSON.fromString(jsonString);
    final WebSocketMessage message = WebSocketMessage.fromJSON(json);
    return message;
  }

  void sendMessage(WebSocketMessage message) => sink?.add(message.encode());

  void sendJSON(JSON data, {String? type, String? topic}) {
    sendMessage(WebSocketMessage(
      type: type,
      topic: topic,
      data: data.map(),
    ));
  }
}

class WebSocketListener {
  WebSocketListener({
    this.onMessage,
    this.onDone,
    this.onError,
  });

  final Function(WebSocketMessage message)? onMessage;
  final Function(Object? error)? onError;
  final Function()? onDone;
}

class WebSocketMessage extends JSON {
  WebSocketMessage({
    String? type,
    String? topic,
    dynamic data,
  }) {
    setType(type);
    setTopic(topic);
    setData(data);
  }

  static WebSocketMessage fromJSON(JSON json) {
    return WebSocketMessage(
      type: json.get(_typeKey),
      topic: json.get(_topicKey),
    );
  }

  String? get type => get(_typeKey);
  bool get hasType => contains(_typeKey);
  void setType(String? type) => set(_typeKey, type);

  String? get topic => get(_topicKey);
  bool get hasTopic => contains(_topicKey);
  void setTopic(String? topic) => set(_topicKey, topic);

  dynamic get data => get(_dataKey);
  bool get hasData => contains(_dataKey);
  void setData(dynamic data) => set(_dataKey, data);
}

String _buildKey(String name) => "websocket_message_$name";
final String _typeKey = _buildKey("type");
final String _topicKey = _buildKey("topic");
final String _dataKey = _buildKey("data");
