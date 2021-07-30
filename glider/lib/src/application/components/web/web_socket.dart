import 'dart:convert';

import 'package:glider_models/glider_models.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_mixins.dart';
import 'web_socket_event.dart';
import 'web_socket_message.dart';

/// Interface for managing a WebSocket connection.
abstract class WebSocketManagement {
  /// Establish a connection with the WebSocket server.
  void openSocket({
    WebSocketEventHandler? eventHandler,
    bool reopenOnDone = true,
  });

  /// Close the WebSocket connection.
  void closeSocket();
}

/// Interface for sending messages to a WebSocket server.
abstract class WebSocketMessaging {
  void send(String body, {String? type, String? category, String? topic});

  /// Send JSON data to the WebSocket server. Essentially the same as sending
  /// the stringified JSON data using `send`.
  void sendJson(JSON body, {String? type, String? category, String? topic});

  /// Send a [WebSocketMessage] to the server.
  void sendMessage(WebSocketMessage message);
}

/// Interface for an object that makes use of a WebSocket for
/// communication.
abstract class WebSocketInterface
    implements WebSocketManagement, WebSocketMessaging {
  /// Send a message to the WebSocket server with a [String] message body.

  /// Indicates if the WebSocket has a listener attached to the stream.
  bool get hasListener;

  /// Indicates if the WebSocket doesn't have a listener attached to the stream.
  bool get hasNoListener => !hasListener;

  /// Indicates if the WebSocket connection is open.
  bool get isOpen;

  /// Indicates if the WebSocket connection is closed.
  bool get isClosed => !isOpen;
}

/// Basic implementation of the [WebSocketInterface] interface.
class WebSocket extends WebSocketInterface with WebHost, UUID {
  WebSocket({
    required this.host,
    required this.port,
  });

  final String host;
  final int port;

  WebSocketChannel? _channel;
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
    bool reopenOnDone = true,
  }) {
    final url = 'ws://$host:$port';
    _channel = WebSocketChannel.connect(Uri.parse(url));

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
    final wsMessage = WebSocketMessage(
      sender: uuid,
      category: category,
      type: type,
      topic: topic,
      body: message,
    );
    sendMessage(wsMessage);
  }

  @override
  void sendJson(JSON data, {String? type, String? category, String? topic}) {
    send(data.encode(), type: type, category: category, topic: topic);
  }

  @override
  void sendMessage(WebSocketMessage message) {
    if (this.isClosed) {
      throw new Exception(
        "WebSocket should be open before calling sendMessage.",
      );
    }
    sink?.add(message.encode());
  }

  WebSocketMessage _parseStreamData(d) {
    final String jsonStr = d is String ? d : jsonEncode(d);
    final JSON json = JSONParser().parse(jsonStr);
    final WebSocketMessage message = WebSocketMessage.fromJSON(json);
    return message;
  }
}
