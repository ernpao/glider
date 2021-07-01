import 'dart:convert';

abstract class Mappable {
  Map<String, dynamic> map();
  String encode() => jsonEncode(map());

  bool containsKey(String key) => keys.contains(key);

  List<String> get keys => map().keys.toList();
  List<dynamic> get values => map().values.toList();
}
