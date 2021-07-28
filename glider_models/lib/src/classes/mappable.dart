/// An object that can be mapped into a series of key/value pairs.
abstract class Mappable {
  /// Create a key/value map of this object.
  Map<String, dynamic> map();

  /// Checks if this object contains the key specified.
  bool contains(String key) => keys.contains(key);

  /// Get the value stored in this object with the string key specified.
  T? get<T>(String key) {
    final val = map()[key];
    if (val == null) {
      return null;
    } else {
      return val as T;
    }
  }

  /// Store a value with a string key in this object.
  void set(String key, dynamic value);

  /// Obtain a list of all the keys stored in this object.
  List<String> get keys => map().keys.toList();

  /// Obtain a list of all the values stored in this object.
  List<dynamic> get values => map().values.toList();

  /// Applies [action] to each key/value pair of the map.
  ///
  /// Calling `action` must not add or remove keys from the map.
  void forEach(void Function(String key, dynamic value) action) {
    map().forEach(action);
  }
}
