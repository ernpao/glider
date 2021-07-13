import 'package:flutter/material.dart';

import 'web_socket.dart';

class WebSocketWidget extends StatefulWidget {
  WebSocketWidget({
    required this.webSocket,
    required this.builder,
    this.reconnectOnDone = true,
  }) : assert(webSocket.hasNoListener);

  final bool reconnectOnDone;
  final WebSocket webSocket;
  final Widget Function(BuildContext, WebSocketEvent?, WebSocket) builder;

  @override
  _WebSocketWidgetState createState() => _WebSocketWidgetState();
}

class _WebSocketWidgetState extends State<WebSocketWidget> {
  WebSocketEvent? lastEvent;

  @override
  void initState() {
    widget.webSocket.openSocket(
      reconnectOnDone: widget.reconnectOnDone,
      listener: WebSocketListener(
        onEvent: (e) => setState(() => this.lastEvent = e),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        lastEvent,
        widget.webSocket,
      );
}
