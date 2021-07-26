import 'dart:convert';

import 'encodable.dart';

abstract class Parseable extends Encodable {
  Map<String, dynamic> _content = {};

  /// Replace the content of this object.
  void _setContent(Map<String, dynamic> content) => _content = content;

  @override
  Map<String, dynamic> map() => _content;

  @override
  void set(String key, dynamic value) => _content[key] = value;
}

abstract class Parser<T extends Parseable> {
  /// Create an instance of the model
  /// that this [Parser] will parse.
  ///
  /// The [Parseable] created by this method
  /// should be empty and contain no key/value
  /// pairs.
  T instantiateModel();

  T _instantiateEmptyModel() {
    final instance = instantiateModel();
    assert(instance.map().isEmpty);
    return instance;
  }

  /// Attempt to parse `jsonString` into a [Parseable] object.
  ///
  /// This will also convert nested [Map<String, dynamic>]
  /// objects into [Parseable] objects and any strings that are found to
  /// match the ISO8601 date time string format into [DateTime] objects.
  T parse(String string) {
    final parsed = jsonDecode(string, reviver: _reviver);
    if (parsed is T) {
      return parsed;
    } else {
      final map = parsed as Map<String, dynamic>;
      return _instantiateEmptyModel().._setContent(map);
    }
  }

  Object? _reviver(Object? key, Object? value) {
    if (value is Map<String, dynamic>) {
      return _instantiateEmptyModel().._setContent(value);
    } else if (value is String && _isIso8601String(value)) {
      return DateTime.parse(value);
    } else {
      return value;
    }
  }

  /// Copies the contents of a [Parseable] object
  /// to another [Parseable] object.
  static T copyTo<T extends Parseable>(Parseable from, T to) {
    assert(to is Parseable);
    to._setContent(from._content);
    return to;
  }

  /// Regular expression for checking if a string is an ISO8601 time string.
  static final _iso8601RegExp = RegExp(
    r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}(\d{3})Z?$',
  );

  /// Checks if a string is an ISO8601 time string.
  static bool _isIso8601String(String string) {
    final isLocalTimestamp = _iso8601RegExp.hasMatch(string);
    return isLocalTimestamp;
  }
}
