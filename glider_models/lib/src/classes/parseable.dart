import 'dart:convert';

import 'encodable.dart';

class Parseable extends Encodable {
  Map<String, dynamic> _content = {};

  void _setContent(Map<String, dynamic> content) => _content = content;

  @override
  Map<String, dynamic> map() => _content;

  @override
  void set(String key, dynamic value) => _content[key] = value;
}

abstract class Parser<T extends Parseable> {
  /// Create an instance of the model
  /// that this [Parser] will parse.
  T instantiateModel();

  /// Attempt to parse `jsonString` into a [Parseable] object.
  ///
  /// This will also convert nested [Map<String, dynamic>]
  /// objects into [Parseable] objects and any strings that are found to
  /// match the ISO8601 date time string format into [DateTime] objects.
  T parse(String string) {
    final parsed = jsonDecode(
      string,
      reviver: (key, value) {
        if (value is Map<String, dynamic>) {
          return Parseable().._setContent(value);
        } else if (value is String && _isIso8601String(value)) {
          return DateTime.parse(value);
        } else {
          return value;
        }
      },
    );
    if (parsed is Parseable) {
      parsed.forEach((key, value) {
        if (value is Parseable) {
          parsed.set(key, parse(value.encode()));
        }
      });
      return instantiateModel().._setContent(parsed.map());
    } else {
      final map = parsed as Map<String, dynamic>;
      return instantiateModel().._setContent(map);
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
