/// An object that can be mapped as a series of key-value pairs.
abstract class Mappable {
  Map<String, dynamic> map();

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
