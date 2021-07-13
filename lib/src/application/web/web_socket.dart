import 'dart:convert';

// import 'dart:typed_data';

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
    bool reconnectOnDone = true,
  });

  /// Close the WebSocket connection.
  void closeSocket();

  /// Send a message to the WebSocket server.
  void send(String data, {String? type, String? category, String? topic});

  /// Send JSON data to the WebSocket server.
  void sendJson(JSON data, {String? type, String? topic});

  /// Indicates if the WebSocket already has a listener attached to the stream.
  bool get hasListener;
  bool get hasNoListener => !hasListener;
}

class WebSocketClient extends WebSocket with WebHost {
  final String name;
  final String host;
  final int port;

  WebSocketClient({
    required this.name,
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
    bool reconnectOnDone = true,
  }) {
    final url = 'ws://$host:$port';
    _channel = IOWebSocketChannel.connect(url, pingInterval: pingInterval);

    _listener = listener;

    if (_listener != null) {
      _channel?.stream.listen(
        (d) => _listener?.onMessage(_parseStreamData(d)),
        onError: _listener?.onError,
        onDone: () {
          _listener?.onDone();
          if (reconnectOnDone) {
            openSocket(
              listener: _listener,
              pingInterval: pingInterval,
              reconnectOnDone: reconnectOnDone,
            );
          }
        },
      );
    }
  }

  @override
  void closeSocket() => _channel?.sink.close(status.goingAway);

  @override
  void send(String message, {String? type, String? category, String? topic}) {
    sink?.add(WebSocketMessage(
      sender: name,
      category: category,
      type: type,
      topic: topic,
      body: message,
    ).encode());
  }

  @override
  void sendJson(JSON data, {String? type, String? category, String? topic}) =>
      send(data.encode(), type: type, category: category, topic: topic);

  WebSocketMessage _parseStreamData(d) {
    final String jsonStr = d is String ? d : jsonEncode(d);
    final JSON json = JSON.parse(jsonStr);
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
    required this.sender,
    String? category,
    String? type,
    String? topic,
    String? body,
  }) {
    _setSender(sender);
    setType(type);
    setCategory(category);
    setTopic(topic);
    setBody(body);
  }

  final String sender;
  void _setSender(String sender) => _set("sender", sender);

  String? get category => _get("category");
  bool get hasCategory => _contains("category");
  void setCategory(String? category) => _set("category", category);

  String? get type => _get("type");
  bool get hasType => _contains("type");
  void setType(String? type) => _set("type", type);

  String? get topic => _get("topic");
  bool get hasTopic => _contains("topic");
  void setTopic(String? topic) => _set("topic", topic);

  String? get body => _get("body");
  bool get hasBody => _contains("body");
  void setBody(String? body) => _set("body", body);

  dynamic _get<T>(String key) => get<T>("_ws_$key");
  void _set(String key, dynamic value) => set("_ws_$key", value);
  bool _contains(String key) => contains("_ws_$key");

  static WebSocketMessage fromJSON(JSON json) {
    String _extract(String key) => _extract("$key");
    return WebSocketMessage(
      sender: _extract("sender"),
      type: _extract("type"),
      category: _extract("category"),
      topic: _extract("topic"),
      body: _extract("body"),
    );
  }
}

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
