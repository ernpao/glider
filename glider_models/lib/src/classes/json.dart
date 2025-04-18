import 'package:meta/meta.dart';

import '../abstractions/mappable.dart';
import '../abstractions/parseable.dart';

class JSON extends Parseable {
  JSON();

  /// Create a new `JSON` object by parsing a string.
  factory JSON.parse(String string) => _parser.parse(string);

  factory JSON.fromMap(KeyValueStore map) {
    return _parser.parseFromMap(map);
  }

  factory JSON.fromDynamicMap(Map map) {
    KeyValueStore translatedMap = {};
    map.forEach((key, value) {
      translatedMap[key.toString()] = value;
    });
    return _parser.parseFromMap(translatedMap);
  }

  /// Attempt to parse a string into a list of JSON objects.
  static List<JSON> parseList(String string) => _parser.parseList(string);

  static final _parser = _JSONParser();

  /// Get a value stored in this `JSON` object with `key`.
  T? getProperty<T>(String key) => get<T>(key);

  /// Get a list stored in this `JSON` object with `key`.
  List<T>? getListProperty<T>(String key) => getListOf<T>(key);

  /// Set a value in this `JSON` object with `key`.
  void setProperty(String key, dynamic value) => set(key, value);
}

class _JSONParser extends Parser<JSON> {
  @override
  final Map<String, Type?>? typeMap = null;

  @protected
  @override
  JSON createModel() => JSON();
}
