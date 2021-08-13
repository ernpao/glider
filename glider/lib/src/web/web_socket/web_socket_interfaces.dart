import 'dart:async';

import 'package:meta/meta.dart';
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

  /// Open the connection with the WebSocketChannel with
  /// the configured URI.
  @mustCallSuper
  void openSocket() {
    if (!_isOpen) {
      _isOpen = true;
      _channel = WebSocketChannel.connect(uri);
    }
  }

  /// Close the channel connection and send the
  /// "going away" status.
  @mustCallSuper
  Future<void> closeSocket() async {
    if (_isOpen) {
      _isOpen = false;
      await _channel?.sink.close(status.goingAway);
    }
  }
}

/// An interface for attaching listeners to a [WebSocketConnection] stream.
abstract class WebSocketStreamConnection {
  WebSocketConnection get connection;

  bool _reopenOnDone = false;
  WebSocketListener? _listener;

  void listen(WebSocketListener listener, {bool reopenOnDone = true}) {
    _listener = listener;
    _reopenOnDone = reopenOnDone;
    _startListening();
  }

  /// Indicates if the WebSocket has a listener attached to the stream.
  bool get hasListener => listener != null;

  /// Indicates if the WebSocket doesn't have a listener attached to the stream.
  bool get hasNoListener => !hasListener;

  @protected
  WebSocketListener? get listener => _listener;

  bool get reopenOnDone => _reopenOnDone;

  StreamSubscription? _subscription;

  Future<void> _startListening() async {
    await _subscription?.cancel();
    _subscription = null;
    _subscription = connection.channel?.stream
        .asBroadcastStream(
          onCancel: (sub) => sub.pause(),
          onListen: (sub) => sub.resume(),
        )
        .listen(
          listener?.onData,
          onError: listener?.onError,
          onDone: _onDone,
        );
  }

  Future<void> _onDone() async {
    listener?.onDone?.call();
    if (reopenOnDone) _startListening();
  }
}

/// An interface for sending data to a [WebSocketConnection] sink.
abstract class WebSocketSinkConnection {
  WebSocketConnection get connection;

  /// Send/sink string data to the WebSocket.
  void send(String data) {
    if (connection.isClosed) {
      throw new Exception(
        "WebSocketConnection should be open before calling WebSocketConnection.send.",
      );
    }
    connection.channel?.sink.add(data);
  }

  /// Send/sink JSON data to the WebSocket.
  void sendJson(JSON json) => send(json.encode());
}
