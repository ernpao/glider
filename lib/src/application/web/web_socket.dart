import 'dart:convert';

// import 'dart:typed_data';

import 'package:glider_models/glider_models.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_mixins.dart';

abstract class WebSocketClient {
  /// Establish a connection with the WebSocket server.
  void openSocket({
    WebSocketEventHandler? eventHandler,
    Duration? pingInterval,
    bool reopenOnDone = true,
  });

  /// Close the WebSocket connection.
  void closeSocket();

  /// Send a message to the WebSocket server.
  void send(String data, {String? type, String? category, String? topic});

  /// Send JSON data to the WebSocket server.
  void sendJson(JSON data, {String? type, String? topic});

  /// Indicates if the WebSocket has a listener attached to the stream.
  bool get hasListener;

  /// Indicates if the WebSocket doesn't have a listener attached to the stream.
  bool get hasNoListener => !hasListener;

  /// Indicates if the WebSocket connection is open.
  bool get isOpen;

  /// Indicates if the WebSocket connection is closed.
  bool get isClosed => !isOpen;
}

class WebSocket extends WebSocketClient with WebHost, UUID {
  WebSocket({
    required this.host,
    required this.port,
  });

  final String host;
  final int port;

  IOWebSocketChannel? _channel;
  Stream? get stream => _channel?.stream;
  WebSocketSink? get sink => _channel?.sink;

  WebSocketEventHandler? get listener => _eventHandler;
  WebSocketEventHandler? _eventHandler;

  @override
  bool get hasListener => listener != null;

  bool _isOpen = false;

  @override
  bool get isOpen => _isOpen;

  @override
  void openSocket({
    WebSocketEventHandler? eventHandler,
    Duration? pingInterval,
    bool reopenOnDone = true,
  }) {
    final url = 'ws://$host:$port';
    _channel = IOWebSocketChannel.connect(url, pingInterval: pingInterval);

    _isOpen = true;
    _eventHandler = eventHandler;

    if (_eventHandler != null) {
      _channel?.stream.listen(
        (d) => _eventHandler?.onMessage(_parseStreamData(d)),
        onError: _eventHandler?.onError,
        onDone: () {
          _isOpen = false;
          _eventHandler?.onDone();
          if (reopenOnDone) {
            openSocket(
              eventHandler: _eventHandler,
              pingInterval: pingInterval,
              reopenOnDone: reopenOnDone,
            );
          }
        },
      );
    }
  }

  @override
  void closeSocket() {
    _isOpen = false;
    _eventHandler = null;
    _channel?.sink.close(status.goingAway);
  }

  @override
  void send(String message, {String? type, String? category, String? topic}) {
    assert(this.isOpen);
    sink?.add(WebSocketMessage(
      sender: uuid,
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

class WebSocketEventHandler {
  WebSocketEventHandler({required this.onEvent});

  final Function(WebSocketEvent event) onEvent;

  void onMessage(WebSocketMessage message) =>
      onEvent(WebSocketMessageEvent(message));

  void onError(Object? error) => onEvent(WebSocketErrorEvent(error));

  void onDone() => onEvent(WebSocketDoneEvent());
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
    _setCreated(DateTime.now());
  }

  final String sender;
  void _setSender(String sender) => _set("sender", sender);

  DateTime get created => _get<DateTime>("created");
  void _setCreated(DateTime created) => _set("created", created.toString());

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
    String? _extract(String key) => json.content["_ws_$key"];
    return WebSocketMessage(
      sender: _extract("sender")!,
      type: _extract("type"),
      category: _extract("category"),
      topic: _extract("topic"),
      body: _extract("body"),
    ).._setCreated(DateTime.parse(_extract("created").toString()));
  }
}
