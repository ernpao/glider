import 'package:flutter/material.dart';
import 'package:glider/data/src/data_layer.dart';

class WebSocketWidget extends StatefulWidget {
  WebSocketWidget({
    required this.webSocket,
    required this.builder,
  }) : assert(webSocket.hasNoListener);

  final WebSocketInterface webSocket;
  final Widget Function(BuildContext context, WebSocketWidgetSnaphsot snaphsot)
      builder;

  @override
  _WebSocketWidgetState createState() => _WebSocketWidgetState();
}

enum WebSocketWidgetStatus {
  /// Indicates that the widget is currently initializing.
  loading,

  /// Indicates that the connection with the WebSocket has been closed.
  done,
  messageReceived,
  error,
}

class WebSocketWidgetSnaphsot {
  final WebSocketWidgetStatus status;
  final WebSocketMessage? message;
  final Object? error;
  WebSocketWidgetSnaphsot({
    required this.status,
    this.message,
    this.error,
  });

  bool get hasErrorStatus => status == WebSocketWidgetStatus.error;
  bool get hasMessage => status == WebSocketWidgetStatus.messageReceived;
  bool get messageHasData => message?.hasData ?? false;
  String? get messageType => message?.type;
  String? get messageTopic => message?.topic;
  dynamic get messageData => message?.data;
}

class _WebSocketWidgetState extends State<WebSocketWidget> {
  WebSocketWidgetStatus status = WebSocketWidgetStatus.loading;
  WebSocketMessage? message;
  Object? error;

  void _onMessage(WebSocketMessage message) => setState(
        () => {
          this.message = message,
          this.status = WebSocketWidgetStatus.messageReceived,
        },
      );

  void _onError(Object? error) => setState(
        () => {
          this.status = WebSocketWidgetStatus.error,
          this.error = error,
        },
      );

  void _onDone() => setState(
        () => {
          this.status = WebSocketWidgetStatus.done,
        },
      );

  @override
  void initState() {
    status = WebSocketWidgetStatus.loading;
    widget.webSocket.openSocket(
      listener: WebSocketListener(
        onMessage: _onMessage,
        onError: _onError,
        onDone: _onDone,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        WebSocketWidgetSnaphsot(
          status: this.status,
          message: this.message,
        ),
      );
}
