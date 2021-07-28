import 'dart:convert';

import 'encodable.dart';

abstract class Parseable extends Encodable {
  Parseable() {
    _content[_runtimeTypeKey] = runtimeType.toString();
  }

  static const String _runtimeTypeKey = "_parseableType_";
  static String? _getRuntimeTypeString(Map<String, dynamic> map) {
    return map[_runtimeTypeKey];
  }

  Map<String, dynamic> _content = {};

  @override
  Map<String, dynamic> map() => _content;

  @override
  void set(String key, dynamic value) {
    assert(
      key != _runtimeTypeKey,
      "$_runtimeTypeKey is a reserved key for the Parseable class.",
    );
    _content[key] = value;
  }

  Map<String, Type>? get parseMap;

  void _setContent(Map<String, dynamic> content) {
    if (parseMap != null) {
      parseMap!.forEach((key, value) {
        assert(content[key].runtimeType == parseMap![key]);
        set(key, content[key]);
      });
    } else {
      _content = content;
    }
  }
}

abstract class Parser<T extends Parseable> {
  /// Create an instance of the [Parseable] class
  /// that this [Parser] will parse.
  T createParseableModel();

  /// Attempt to parse [string] into a [Parseable] object.
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
      return createParseableModel().._setContent(map);
    }
  }

  late final String _modelRuntimeTypeString = T.toString();

  /// The reviver function used with `jsonDecode` in `parse`.
  ///
  /// This will ensure that the item returned by `jsonDecode`
  /// is either an instance of the [Parseable] handled by this
  /// parser, or a [Map<String, dynamic>] which is then set
  /// as the content of a new instance of the [Parseable].
  Object? _reviver(Object? key, Object? value) {
    if (value is Map<String, dynamic>) {
      final valueType = Parseable._getRuntimeTypeString(value);
      if (valueType == _modelRuntimeTypeString) {
        return createParseableModel().._setContent(value);
      } else {
        return value;
      }
    } else if (value is String && _isIso8601String(value)) {
      return DateTime.parse(value);
    } else {
      return value;
    }
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

  /// Creates an instance of the [Parseable] handled by this parser
  /// from the content of [from]. Behavior of this function
  /// will depend on whether [Parseable] contains a [parseMap] that
  /// is not null.
  ///
  /// If the [Parseable] has a [parseMap] that is not null,
  /// this function will loop through each key in that map
  /// and copy the value from [from] into a new instance of
  /// the [Parseable] only for those keys.
  ///
  /// If the [Parseable] type has a null [parseMap], then this function will
  /// simply copy all of the content of [from] into the a new instance of
  /// the [Parseable].
  T parseFrom<F extends Parseable>(F from) {
    final model = createParseableModel();
    final targetMap = model.parseMap;

    if (targetMap != null) {
      targetMap.forEach((key, value) {
        if (from.contains(key)) {
          model.set(key, from.get(key));
        }
      });
    } else {
      model._setContent(from.map());
    }

    return model;
  }
}
