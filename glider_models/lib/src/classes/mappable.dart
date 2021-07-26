import 'dart:convert';

abstract class Mappable {
  Map<String, dynamic> map();

  /// Converts this [Mappable] into a string via the `dart:convert`
  /// library's `jsonEncode` function.
  ///
  /// This will also convert [DateTime]
  /// objects in the map into ISO8601 strings and other [Mappable] objects
  /// into [Map<String, dynamic>] in order for `jsonEncode` to work.
  String encode() => jsonEncode(map(), toEncodable: toEncodeable);

  /// Converts [nonEncodable] to an encodable object for use
  /// with encoding functions such as `jsonEncode`.
  Object? toEncodeable(Object? nonEncodable) {
    if (nonEncodable is Mappable) {
      return nonEncodable.map();
    } else if (nonEncodable is DateTime) {
      return nonEncodable.toIso8601String();
    }
  }

  bool contains(String key) => keys.contains(key);

  T? get<T>(String key) => map()[key] as T;

  void set(String key, dynamic value);

  List<String> get keys => map().keys.toList();

  List<dynamic> get values => map().values.toList();

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  void forEach(void Function(String key, dynamic value) action) {
    map().forEach(action);
  }
}
