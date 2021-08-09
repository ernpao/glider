import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../web_mixins.dart';
import 'web_socket_listeners.dart';

/// The base class for composing WebSocket classes which allows
/// the opening and closing of connections.
///
/// This is also the class through which the [WebSocketChannel]
/// of the socket is exposed through `channel` which can be used
/// to access the stream for sinking or listening to data.
class WebSocketConnection with WebURI {
  bool get isClosed => !isOpen;

  WebSocketConnection({
    required this.host,
    this.port,
    this.path,
    this.useWss = false,
  });

  /// Indicates if the scheme used by the socket is 'wss://' or 'ws://'
  final bool useWss;

  @override
  String get scheme => useWss ? wssScheme : wsScheme;

  @override
  final String host;

  @override
  final int? port;

  @override
  final String? path;

  @protected
  WebSocketChannel? get channel => _channel;
  WebSocketChannel? _channel;

  bool _isOpen = false;
  bool get isOpen => _isOpen;

  @mustCallSuper
  void openSocket() {
    _isOpen = true;
    _channel = WebSocketChannel.connect(uri);
  }

  @mustCallSuper
  void closeSocket() {
    _isOpen = false;
    _channel?.sink.close(status.goingAway);
  }
}

/// An interface for attaching listeners to a [WebSocketConnection] stream.
abstract class WebSocketStreamConnection {
  WebSocketListener? _listener;
  WebSocketConnection get connection;

  bool _reopenOnDone = false;
  bool get reopenOnDone => _reopenOnDone;

  void listen(WebSocketListener listener, {bool reopenOnDone = true}) {
    _listener = listener;
    _reopenOnDone = reopenOnDone;
    _startListening();
  }

  /// Indicates if the WebSocket has a listener attached to the stream.
  bool get hasListener => listener != null;

  /// Indicates if the WebSocket doesn't have a listener attached to the stream.
  bool get hasNoListener => !hasListener;

  WebSocketListener? get listener => _listener;

  void _startListening() {
    connection.channel?.stream.listen(
      listener?.onData,
      onError: listener?.onError,
      onDone: _onDone,
    );
  }

  void _onDone() {
    listener?.onDone?.call();
    if (reopenOnDone) {
      _startListening();
    } else {
      connection.closeSocket();
    }
  }
}

/// An interface for sending data to a [WebSocketConnection] sink.
abstract class WebSocketSinkConnection {
  WebSocketConnection get connection;
  void send(String data) {
    if (connection.isClosed) {
      throw new Exception(
        "WebSocketConnection should be open before calling WebSocketConnection.send.",
      );
    }
    connection.channel?.sink.add(data);
  }

  void sendJson(JSON json) => send(json.encode());
}
