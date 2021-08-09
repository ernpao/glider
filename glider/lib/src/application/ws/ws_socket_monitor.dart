import 'package:flutter/material.dart';

import '../components/web/web.dart';
import 'ws_event.dart';
import 'ws_message_listener.dart';
import 'ws_socket.dart';

/// A widget for listening to WsMessages.
class WS_SocketMonitor extends StatefulWidget {
  WS_SocketMonitor({
    required this.socket,
    required this.builder,
    this.reopenOnDone = true,
  }) {
    if (socket.isOpen) {
      throw new Exception(
        "WS_Socket provided to a WS_Monitor should be closed.",
      );
    }
  }

  /// Reopen the connection when the done event is fired.
  final bool reopenOnDone;

  /// An object that implements the [WebSocketStreamChannel] interface or an instance of the [WebSocketStreamChannel] class.
  final WS_Socket socket;

  final Widget Function(BuildContext context, WS_Event? event) builder;

  @override
  _WS_SocketMonitorState createState() => _WS_SocketMonitorState();
}

class _WS_SocketMonitorState extends State<WS_SocketMonitor> {
  WS_Event? _event;

  @override
  void initState() {
    widget.socket.openSocket();
    widget.socket.listen(
      WsMessageListener(onMessage: (webSocketMessage) {
        setState(() => _event = WS_MessageEvent(webSocketMessage));
      }, onDone: () {
        setState(() => _event = WS_DoneEvent());
      }, onError: (error) {
        setState(() => _event = WS_ErrorEvent(error));
      }),
      reopenOnDone: widget.reopenOnDone,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _event);
}
