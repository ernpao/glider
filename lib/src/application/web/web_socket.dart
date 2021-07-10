import 'dart:convert';
import 'dart:typed_data';

import 'package:glider_models/glider_models.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_mixins.dart';

abstract class WebSocket {
  /// Establish a connection with the WebSocket server.
  void openSocket({
    WebSocketListener? listener,
    Duration? pingInterval,
    bool? retryOnDone,
  });

  /// Close the WebSocket connection.
  void closeSocket();

  /// Send a message to the WebSocket server.
  void send(WebSocketMessage message);

  /// Send JSON data to the WebSocket server.
  void sendJson(JSON data, {String? type, String? topic});

  /// Indicates if the WebSocket already has a listener attached to the stream.
  bool get hasListener;
  bool get hasNoListener => !hasListener;
}

class WebSocketClient extends WebSocket with WebHost {
  final String host;
  final int port;

  WebSocketClient({
    required this.host,
    required this.port,
  });

  IOWebSocketChannel? _channel;
  Stream? get stream => _channel?.stream;
  WebSocketSink? get sink => _channel?.sink;

  WebSocketListener? get listener => _listener;
  WebSocketListener? _listener;

  @override
  bool get hasListener => listener != null;

  @override
  void openSocket({
    WebSocketListener? listener,
    Duration? pingInterval,
    bool? retryOnDone,
  }) {
    _channel = IOWebSocketChannel.connect(
      'ws://$host:$port',
      pingInterval: pingInterval,
    );

    _listener = listener;

    if (listener != null) {
      _channel?.stream.listen(
        (d) => listener.onMessage(_convertStreamData(d)),
        onError: listener.onError,
        onDone: () {
          listener.onDone();
          if (retryOnDone != null) {
            if (retryOnDone) {
              openSocket(
                listener: listener,
                pingInterval: pingInterval,
                retryOnDone: retryOnDone,
              );
            }
          }
        },
      );
    }
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
      data: data.content,
    ));
  }

  WebSocketMessage _convertStreamData(d) {
    final String jsonStr = d is String ? d : jsonEncode(d);
    final JSON json = JSON.parse(jsonStr);
    if (json.contains("type")) {
      switch (json.get("type")) {
        case "Buffer":
          final List<dynamic> data = json.get("data");
          final List<int> ints = data.map((i) => i as int).toList();
          final bytes = Uint8List.fromList(ints);
          final message = WebSocketMessage(type: "buffer", data: bytes);
          return message;
        default:
          break;
      }
    }
    final WebSocketMessage message = WebSocketMessage.fromJSON(json);
    return message;
  }
}

class WebSocketListener {
  WebSocketListener({
    required this.onEvent,
  });

  final Function(WebSocketEvent event) onEvent;

  void onMessage(WebSocketMessage message) =>
      onEvent(WebSocketMessageEvent(message));

  void onError(Object? error) => onEvent(WebSocketErrorEvent(error));

  void onDone() => onEvent(WebSocketDoneEvent());
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
      data: json.get(_dataKey),
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

String _buildKey(String name) => "_ws_$name";
final String _typeKey = _buildKey("type");
final String _topicKey = _buildKey("topic");
final String _dataKey = _buildKey("data");

abstract class WebSocketEvent {
  bool get isMessageEvent => this is WebSocketMessageEvent;
  bool get isErrorEvent => this is WebSocketErrorEvent;
  bool get isDoneEvent => this is WebSocketDoneEvent;
}

class WebSocketDoneEvent extends WebSocketEvent {}

class WebSocketMessageEvent extends WebSocketEvent {
  final WebSocketMessage message;
  WebSocketMessageEvent(this.message);
}

class WebSocketErrorEvent extends WebSocketEvent {
  final Object? error;
  WebSocketErrorEvent(this.error);
  bool get hasError => error != null;
}
