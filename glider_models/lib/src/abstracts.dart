library abstracts;

import 'dart:convert';

abstract class Mappable {
  Map<String, dynamic> map();
  String encode() => jsonEncode(map());

  bool contains(String key) => keys.contains(key);
  T get<T>(String key) => map()[key] as T;

  /// Returns the key of the value provided
  /// if it is in the map.
  String? keyOf(dynamic value) {}

  List<String> get keys => map().keys.toList();
  List<dynamic> get values => map().values.toList();

  void forEach(void Function(String, dynamic) action) => map().forEach(action);
}
