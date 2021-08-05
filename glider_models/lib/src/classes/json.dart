import 'package:flutter/foundation.dart';

import 'parseable.dart';

class JSON extends Parseable {
  JSON();

  /// Create a new `JSON` object by parsing a string.
  factory JSON.parse(String string) => _parser.parse(string);

  factory JSON.fromMap(Map<String, dynamic> map) => _parser.parseFromMap(map);

  static List<JSON> parseList(String string) => _parser.parseList(string);

  static final _parser = _JSONParser();

  /// Get a value stored in this `JSON` object with `key`.
  T? getProperty<T>(String key) => get<T>(key);

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
