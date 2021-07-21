import 'dart:convert';

import 'mappable.dart';

class JSON extends Mappable {
  Map<String, dynamic> _content = {};
  Map<String, dynamic> get content => _content;

  void set(String key, dynamic value) => _content[key] = value;

  @override
  Map<String, dynamic> map() => _content;

  void _setContent(Map<String, dynamic> content) => _content = content;

  /// Attempt to parse `jsonString` into a [JSON] object.
  ///
  /// This will also convert nested [Map<String, dynamic>]
  /// objects into [JSON] objects and any strings that are found to
  /// match the ISO8601 date time string format into [DateTime] objects.
  static JSON parse(String jsonString) {
    final parsed = jsonDecode(
      jsonString,
      reviver: (key, value) {
        if (value is Map<String, dynamic>) {
          return JSON().._setContent(value);
        } else if (value is String && _isIso8601String(value)) {
          return DateTime.parse(value);
        } else {
          return value;
        }
      },
    );
    if (parsed is JSON) {
      return parsed;
    } else {
      final map = parsed as Map<String, dynamic>;
      return JSON().._setContent(map);
    }
  }

  String get prettified => const JsonEncoder.withIndent('  ').convert(_content);

  String stringify() => encode();

  @override
  String toString() => prettified;

  /// Copies the contents of a [JSON] object
  /// to another [JSON] object.
  static T copyAs<T extends JSON>(JSON from, T to) {
    to._setContent(from._content);
    return to;
  }
}

final _iso8601RegExp = RegExp(
  r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}(\d{3})Z?$',
);

bool _isIso8601String(String string) {
  final isLocalTimestamp = _iso8601RegExp.hasMatch(string);
  return isLocalTimestamp;
}
