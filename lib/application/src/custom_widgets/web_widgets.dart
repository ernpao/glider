import 'package:flutter/material.dart';

import '../../../data/src/data_layer.dart';

class WebSocketWidget extends StatefulWidget {
  WebSocketWidget({
    required this.webSocket,
    required this.builder,
    this.retryOnDone,
  }) : assert(webSocket.hasNoListener);

  final bool? retryOnDone;
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
      retryOnDone: widget.retryOnDone,
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
