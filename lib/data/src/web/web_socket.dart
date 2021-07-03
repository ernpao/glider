import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'mixins.dart';

abstract class WebSocket<T> with WebHost {
  final String host;
  final int port;

  WebSocket({required this.host, required this.port});

  IOWebSocketChannel? _channel;
  Stream? get stream => _channel?.stream;

  bool get connected => _channel != null;
  bool get notConnected => !connected;

  void connect({Duration? pingInterval}) {
    if (notConnected) {
      _channel = IOWebSocketChannel.connect(
        'ws://$host:$port',
        pingInterval: pingInterval,
      );
    }
  }

  void listen(WebSocketListener listener) {
    if (_channel != null) {
      stream?.listen(
        listener.onData,
        onError: listener.onError,
        onDone: listener.onDone,
      );
    } else {
      print("Can't listen to stream because channel is null!");
    }
  }

  void send(dynamic data) {
    _channel?.sink.add(data);
    _channel?.sink.close(status.goingAway);
  }
}

abstract class WebSocketListener {
  void onData(dynamic data);
  void onError(Object? error);
  void onDone();
}
