import 'dart:convert';

import 'package:glider_models/glider_models.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'web_mixins.dart';
import 'web_socket_event.dart';
import 'web_socket_message.dart';

/// Interface for managing a WebSocket connection.
abstract class WebSocketManager {
  /// Establish a connection with the WebSocket server.
  void openSocket({
    WebSocketEventHandler? eventHandler,
    bool reopenOnDone = true,
  });

  /// Close the WebSocket connection.
  void closeSocket();
}

/// Interface for sending messages to a WebSocket server.
abstract class WebSocketMessenger {
  /// Function for sending string content to the WebSocket server.
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
    implements WebSocketManager, WebSocketMessenger {
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
/// The [UUID] of the [WebSocket] is set in the
class WebSocket extends WebSocketInterface with WebHost, UUID {
  WebSocket({
    required this.host,
    this.port,
    this.path,
  });

  final String host;
  final int? port;
  final String? path;

  WebSocketChannel? _channel;
  WebSocketEventHandler? _eventHandler;

  @override
  bool get hasListener => _eventHandler != null;

  bool _isOpen = false;

  @override
  bool get isOpen => _isOpen;

  KeyValueStore _queryParameters = {};
  KeyValueStore get queryParameters => _queryParameters;

  /// Adds a query paramter to the URI of the port.
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  @override
  void openSocket({
    WebSocketEventHandler? eventHandler,
    bool reopenOnDone = true,
  }) {
    final uri = Uri(
      host: host,
      scheme: "ws",
      port: port,
      path: path,
      queryParameters: _queryParameters,
    );
    _channel = WebSocketChannel.connect(uri);

    _isOpen = true;
    _eventHandler = eventHandler;

    if (_eventHandler != null) {
      _channel?.stream.listen(
        (d) => _eventHandler?.onMessage(_parseStreamData(d)),
        onError: _eventHandler?.onError,
        onDone: () => _onDone(reopenOnDone),
      );
    }
  }

  void _onDone(bool reopenOnDone) {
    _isOpen = false;
    _eventHandler?.onDone();
    if (reopenOnDone) {
      openSocket(eventHandler: _eventHandler, reopenOnDone: reopenOnDone);
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
    _channel?.sink.add(message.encode());
  }

  JSON? _streamDataToJson(data) {
    if (data == null) return null;
    final String jsonStr = data is String ? data : jsonEncode(data);
    final JSON json = JSON.parse(jsonStr);
    return json;
  }

  WebSocketMessage? _parseStreamData(data) {
    final json = _streamDataToJson(data);
    if (json != null) {
      final WebSocketMessage message = WebSocketMessage.fromJson(json);
      return message;
    }
  }
}
