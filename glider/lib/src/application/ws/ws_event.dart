import 'package:glider_models/glider_models.dart';

import 'ws_message.dart';

abstract class WS_Event {
  bool get isMessageEvent => this is WS_MessageEvent;
  bool get isMessageEventWithMessage {
    return isMessageEvent && (this as WS_MessageEvent).withData;
  }

  bool get isErrorEvent => this is WS_ErrorEvent;
  bool get isDoneEvent => this is WS_DoneEvent;

  T _as<T>() {
    assert(this is T);
    return this as T;
  }

  /// Casts self as a [WS_MessageEvent]
  WS_MessageEvent asDataEvent() => _as<WS_MessageEvent>();

  /// Casts self as a [WS_DoneEvent]
  WS_DoneEvent asDoneEvent() => _as<WS_DoneEvent>();

  /// Casts self as a [WS_ErrorEvent]
  WS_ErrorEvent asErrorEvent() => _as<WS_ErrorEvent>();
}

class WS_DoneEvent extends WS_Event {}

class WS_MessageEvent extends WS_Event {
  WS_MessageEvent(this.data);

  /// [WS_Message] received from the [WebSocket].
  ///
  /// This [WS_Message] will always be created from
  /// [WS_Message].`fromJson` so [WS_Message].`rawData` can be
  /// accessed to get the [JSON] data if `message` does not have the predefined
  /// fields in [WS_Message].
  final WS_Message? data;

  JSON? get dataAsJson => data?.rawData;

  bool get withData => data != null;
}

class WS_ErrorEvent extends WS_Event {
  final Object? error;
  WS_ErrorEvent(this.error);
  bool get hasError => error != null;
}
