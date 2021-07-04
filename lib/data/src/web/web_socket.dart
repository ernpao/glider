import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/models.dart';
import 'mixins.dart';

abstract class WebSocketInterface {
  /// Establish a connection with the WebSocket server.
  void openSocket(
      {required WebSocketListener listener, Duration? pingInterval});

  /// Close the WebSocket connection.
  void closeSocket();

  /// Send a message to the WebSocket server.
  void send(WebSocketMessage message);

  /// Send JSON data to the WebSocket server.
  void sendJson(JSON data, {String? type, String? topic});
}

class WebSocket with WebHost implements WebSocketInterface {
  final String host;
  final int port;

  WebSocket({
    required this.host,
    required this.port,
  });

  IOWebSocketChannel? _channel;
  Stream? get stream => _channel?.stream;
  WebSocketSink? get sink => _channel?.sink;

  @override
  void openSocket(
      {required WebSocketListener listener, Duration? pingInterval}) {
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

  @override
  void closeSocket() => _channel?.sink.close(status.goingAway);

  @override
  void send(WebSocketMessage message) => sink?.add(message.encode());

  @override
  void sendJson(JSON data, {String? type, String? topic}) {
    send(WebSocketMessage(
      type: type,
      topic: topic,
      data: data.map(),
    ));
  }

  WebSocketMessage _convertStreamData(d) {
    final String jsonString = d is String ? d : jsonEncode(d);
    final JSON json = JSON.fromString(jsonString);
    final WebSocketMessage message = WebSocketMessage.fromJSON(json);
    return message;
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
