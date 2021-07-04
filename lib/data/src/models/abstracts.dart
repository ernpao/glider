library abstracts;

import 'dart:convert';

abstract class Mappable {
  Map<String, dynamic> map();
  String encode() => jsonEncode(map());

  bool contains(String key) => keys.contains(key);
  dynamic get(String key) => map()[key];

  /// Returns the key of the value provided
  /// if it is in the map.
  String? keyOf(dynamic value) {}

  List<String> get keys => map().keys.toList();
  List<dynamic> get values => map().values.toList();
}
