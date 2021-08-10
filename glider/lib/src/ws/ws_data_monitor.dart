import 'package:flutter/material.dart';

import '../web/web.dart';
import 'ws_event.dart';
import 'ws_data_listener.dart';
import 'ws_socket.dart';

/// A widget for listening to WsDatas.
class WsDataMonitor extends StatefulWidget {
  WsDataMonitor({
    required this.socket,
    required this.builder,
    this.reopenOnDone = true,
  }) {
    if (socket.isOpen) {
      throw new Exception(
        "WsSocket provided to a WsMonitor should be closed.",
      );
    }
  }

  /// Reopen the connection when the done event is fired.
  final bool reopenOnDone;

  /// An object that implements the [WebSocketStreamChannel] interface or an instance of the [WebSocketStreamChannel] class.
  final WsSocket socket;

  final Widget Function(BuildContext context, WsEvent? event) builder;

  @override
  _WsDataMonitorState createState() => _WsDataMonitorState();
}

class _WsDataMonitorState extends State<WsDataMonitor> {
  WsEvent? _lastEvent;

  @override
  void initState() {
    widget.socket.openSocket();
    widget.socket.listen(
      WsDataListener(onMessage: (webSocketMessage) {
        setState(() => _lastEvent = WsDataEvent(webSocketMessage));
      }, onDone: () {
        setState(() => _lastEvent = WsDoneEvent());
      }, onError: (error) {
        setState(() => _lastEvent = WsErrorEvent(error));
      }),
      reopenOnDone: widget.reopenOnDone,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _lastEvent);
}
