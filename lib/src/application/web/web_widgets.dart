import 'package:flutter/material.dart';

import 'web_socket.dart';

class WebSocketMonitor extends StatefulWidget {
  WebSocketMonitor({
    required this.webSocket,
    required this.builder,
    this.reopenOnDone = true,
  }) : assert(webSocket.isClosed);

  /// Reopen the connection when the done event is fired.
  final bool reopenOnDone;

  /// An object that implements the [WebSocketClient] interface or an instance of the [WebSocket] class.
  final WebSocketClient webSocket;
  final Widget Function(BuildContext, WebSocketEvent?) builder;

  @override
  _WebSocketMonitorState createState() => _WebSocketMonitorState();
}

class _WebSocketMonitorState extends State<WebSocketMonitor> {
  WebSocketEvent? _event;

  @override
  void initState() {
    widget.webSocket.openSocket(
      reopenOnDone: widget.reopenOnDone,
      eventHandler:
          WebSocketEventHandler(onEvent: (e) => setState(() => _event = e)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _event);
}
