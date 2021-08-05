import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'encodable.dart';
import 'stringifiable.dart';

class Parseable extends Encodable with Stringifiable {
  Parseable() {
    _setTypeInContent();
  }

  static const String _typeKey = "__type";

  void _setTypeInContent() {
    _content[_typeKey] = runtimeType.toString();
  }

  Map<String, dynamic> _content = {};

  @override
  Map<String, dynamic> map() => _content;

  @protected
  @override
  void set(String key, dynamic value) {
    if (key == _typeKey) {
      throw Exception("$_typeKey is a reserved key for the Parseable class.");
    }
    _content[key] = value;
  }

  /// Copy [content] into this object
  void _setContent(
      Map<String, dynamic> content, Map<String, dynamic>? typeMap) {
    if (typeMap != null) {
      typeMap.forEach((key, value) {
        final parseMapType = typeMap[key]?.toString();
        final contentValue = content[key];
        final contentValueType = contentValue.runtimeType.toString();

        if (parseMapType != null &&
            parseMapType != contentValueType &&
            contentValue != null) {
          throw Exception(
            "Parse map error in Parseable. A type of '$parseMapType' is expected "
            "for the value of '$key' but '$contentValueType' was found.",
          );
        }

        set(key, content[key]);
      });
    } else {
      _content = content;
      _setTypeInContent();
    }
  }

  T? _get<T>(String key) => get<T>(key);

  @override
  String stringify() => encode();
}

abstract class Parser<T extends Parseable> {
  /// Create an instance of the [Parseable] class
  /// that this [Parser] will parse.
  @protected
  T createModel();

  /// A key/type map that the `parse` function
  /// will use to determine which key/value pairs
  /// to copy from the parsed content and insert
  /// in the base object created by `createModel`.
  Map<String, Type?>? get typeMap;

  /// Attempt to parse string into a [Parseable] object.
  ///
  /// This will also convert nested [Map<String, dynamic>]
  /// objects into [Parseable] objects and any strings that are found to
  /// match the ISO8601 date time string format into [DateTime] objects.
  T parse(String string) {
    final decoded = jsonDecode(string, reviver: _reviver);
    return decoded is T
        ? decoded
        : parseFromMap(decoded as Map<String, dynamic>);
  }

  List<T> parseList(String string) {
    final parsedList = <T>[];
    final decodedList = jsonDecode(string, reviver: _reviver) as List;

    for (var item in decodedList) {
      final map = item as Map<String, dynamic>;
      parsedList.add(parseFromMap(map));
    }

    return parsedList;
  }

  T parseFromMap(Map<String, dynamic> map) {
    return createModel().._setContent(map, typeMap);
  }

  late final String _expectedType = T.toString();

  /// The reviver function used with `jsonDecode` in `parse`.
  ///
  /// This will ensure that the item returned by `jsonDecode`
  /// is either an instance of the [Parseable] handled by this
  /// parser, or a [Map]<String, dynamic> which is then set
  /// as the content of a new instance of the [Parseable].
  Object? _reviver(Object? key, Object? value) {
    if (value is Map<String, dynamic>) {
      final valueType = value[Parseable._typeKey];
      return valueType == _expectedType ? parseFromMap(value) : value;
    } else if (value is String && _iso8601RegExp.hasMatch(value)) {
      return DateTime.parse(value);
    } else {
      return value;
    }
  }

  /// Regular expression for checking if a string is an ISO8601 time string.
  static final _iso8601RegExp = RegExp(
    r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}(\d{3})Z?$',
  );

  /// Translate a [Parsable] into another [Parseable].
  ///
  /// Translates `from` into an instance of the [Parseable] class handled by this parser.
  /// Behavior of this function
  /// will depend on whether [typeMap] is null or not.
  ///
  /// If [typeMap] is not null,
  /// this function will map the value from `from` into a new [Parseable]
  /// created with [_createModel] using the key/type mapping
  /// in [typeMap].
  ///
  /// If [typeMap] is null, then this function will
  /// simply copy all of the content of `from` into a new [Parseable]
  /// created with [_createModel].
  T translateFrom<F extends Parseable>(F from) {
    final model = createModel();

    if (typeMap != null) {
      typeMap!.forEach((key, value) {
        if (from.contains(key)) {
          model.set(key, from._get(key));
        }
      });
    } else {
      model._setContent(from.map(), typeMap);
    }

    return model;
  }
}
