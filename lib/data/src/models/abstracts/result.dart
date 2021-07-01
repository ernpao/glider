import '../../data_layer.dart';

abstract class Result with DebugConsoleLogging {
  bool get success;
  String get message;

  @override
  String toString() =>
      "${this.runtimeType} as Result is${success ? " " : " not "}successful. $message";
}
