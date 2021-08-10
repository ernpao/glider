import 'package:glider_models/glider_models.dart';

import 'ws_data.dart';

abstract class WsEvent {
  bool get isDataEvent => this is WsDataEvent;
  bool get isDataEventWithData {
    return isDataEvent && (this as WsDataEvent).withData;
  }

  bool get isErrorEvent => this is WsErrorEvent;
  bool get isDoneEvent => this is WsDoneEvent;

  T _as<T>() {
    assert(this is T);
    return this as T;
  }

  /// Casts self as a [WsDataEvent]
  WsDataEvent asDataEvent() => _as<WsDataEvent>();

  /// Casts self as a [WsDoneEvent]
  WsDoneEvent asDoneEvent() => _as<WsDoneEvent>();

  /// Casts self as a [WsErrorEvent]
  WsErrorEvent asErrorEvent() => _as<WsErrorEvent>();
}

class WsDoneEvent extends WsEvent {}

class WsDataEvent extends WsEvent {
  WsDataEvent(this.data);

  /// [WsData] received from the [WebSocket].
  ///
  /// This [WsData] will always be created from
  /// [WsData].`fromJson` so [WsData].`rawData` can be
  /// accessed to get the [JSON] data if `message` does not have the predefined
  /// fields in [WsData].
  final WsData? data;

  JSON? get dataAsJson => data?.rawData;

  bool get withData => data != null;
}

class WsErrorEvent extends WsEvent {
  final Object? error;
  WsErrorEvent(this.error);
  bool get hasError => error != null;
}
