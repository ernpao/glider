import 'web_socket_message.dart';

abstract class WebSocketEvent {
  bool get isMessageEvent => this is WebSocketMessageEvent;
  bool get isErrorEvent => this is WebSocketErrorEvent;
  bool get isDoneEvent => this is WebSocketDoneEvent;

  T _as<T>() {
    assert(this is T);
    return this as T;
  }

  /// Casts self as a [WebSocketMessageEvent]
  WebSocketMessageEvent asMessageEvent() => _as<WebSocketMessageEvent>();

  /// Casts self as a [WebSocketDoneEvent]
  WebSocketDoneEvent asDoneEvent() => _as<WebSocketDoneEvent>();

  /// Casts self as a [WebSocketErrorEvent]
  WebSocketErrorEvent asErrorEvent() => _as<WebSocketErrorEvent>();
}

class WebSocketDoneEvent extends WebSocketEvent {}

class WebSocketMessageEvent extends WebSocketEvent {
  final WebSocketMessage? message;
  WebSocketMessageEvent(this.message);
}

class WebSocketErrorEvent extends WebSocketEvent {
  final Object? error;
  WebSocketErrorEvent(this.error);
  bool get hasError => error != null;
}

/// A class that processes WebSocket events (i.e. [WebSocketEvent] objects).
class WebSocketEventHandler {
  WebSocketEventHandler({required this.onEvent});

  final Function(WebSocketEvent event) onEvent;

  void onMessage(WebSocketMessage? message) =>
      onEvent(WebSocketMessageEvent(message));

  void onError(Object? error) => onEvent(WebSocketErrorEvent(error));

  void onDone() => onEvent(WebSocketDoneEvent());
}
