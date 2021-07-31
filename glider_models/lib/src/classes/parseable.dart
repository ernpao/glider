import 'dart:convert';

import 'encodable.dart';
import 'stringifiable.dart';

abstract class Parseable extends Encodable with Stringifiable {
  Parseable() {
    _setRuntimeTypeInContent();
  }

  static const String _runtimeTypeKey = "__type";

  void _setRuntimeTypeInContent() {
    _content[_runtimeTypeKey] = runtimeType.toString();
  }

  Map<String, dynamic> _content = {};

  @override
  Map<String, dynamic> map() => _content;

  @override
  void set(String key, dynamic value) {
    if (key == _runtimeTypeKey) {
      throw Exception(
        "$_runtimeTypeKey is a reserved key for the Parseable class.",
      );
    }
    _content[key] = value;
  }

  void _setContent(Map<String, dynamic> content, Map<String, Type>? typeMap) {
    if (typeMap != null) {
      typeMap.forEach((key, value) {
        final parseMapType = typeMap[key].toString();
        final contentValue = content[key];
        final contentValueType = contentValue.runtimeType.toString();

        if (contentValue == null) {
          throw Exception(
            "Parse map error in Parseable."
            "The '$key' element is missing in the content and is expected to"
            "not be null since it is defined in the parse map of ${runtimeType.toString()}.",
          );
        }

        if (parseMapType != contentValueType) {
          throw Exception(
            "Parse map error in Parseable."
            "Value in the Parseable's content has a type of"
            "'$contentValueType' but '$parseMapType' is expected as defined in the parse map."
            "Make sure that the type set in the parse map of ${runtimeType.toString()} for '$key'"
            "is the same as the type of the content value.  ",
          );
        }

        set(key, content[key]);
      });
    } else {
      _content = content;
      _setRuntimeTypeInContent();
    }
  }

  @override
  String stringify() => encode();
}

abstract class Parser<T extends Parseable> {
  /// Create an instance of the [Parseable] class
  /// that this [Parser] will parse.
  T createModel();

  /// A key/type map which will be used for
  /// parsing.
  Map<String, Type>? get typeMap;

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
      return createModel().._setContent(map, typeMap);
    }
  }

  T parseFromMap(Map<String, dynamic> map) {
    return createModel().._setContent(map, typeMap);
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
      final valueType = value[Parseable._runtimeTypeKey];
      if (valueType == _modelRuntimeTypeString) {
        return createModel().._setContent(value, typeMap);
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

  /// Translate a [Parsable] into another [Parseable].
  ///
  /// Translates `from` into an instance of the [Parseable] class handled by this parser.
  /// Behavior of this function
  /// will depend on whether [typeMap] is null or not.
  ///
  /// If [typeMap] is not null,
  /// this function will map the value from `from` into a new [Parseable]
  /// created with [createModel] using the key/type mapping
  /// in [typeMap].
  ///
  /// If [typeMap] is null, then this function will
  /// simply copy all of the content of `from` into a new [Parseable]
  /// created with [createModel].
  T translate<F extends Parseable>(F from) {
    final model = createModel();
    final mapping = typeMap;

    if (mapping != null) {
      mapping.forEach((key, value) {
        if (from.contains(key)) {
          model.set(key, from.get(key));
        }
      });
    } else {
      model._setContent(from.map(), typeMap);
    }

    return model;
  }
}
