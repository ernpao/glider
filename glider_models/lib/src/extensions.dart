import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'abstractions/mappable.dart';

extension ResponseExtensions on Response {
  dynamic get decodedBody => jsonDecode(body);
  KeyValueStore? get bodyAsMap {
    try {
      if (decodedBody is! Map) return null;
      return decodedBody as KeyValueStore;
    } catch (e) {
      debugPrint(
        "ResponseExtensions.bodyAsMap can't convert the body of this http response into a KeyValueStore: '$body'",
      );
      return null;
    }
  }

  String get _statusCodeString => statusCode.toString();
  bool get hasStatusCode2XX => _statusCodeString.startsWith("2");
  bool get hasStatusCode3XX => _statusCodeString.startsWith("3");
  bool get hasStatusCode4XX => _statusCodeString.startsWith("4");
  bool get hasStatusCode5XX => _statusCodeString.startsWith("5");
  bool get _hasSuccessKey => bodyAsMap?.keys.contains("success") ?? false;
  bool get _successKeyValue => bodyAsMap?["success"];
  bool get isSuccessful => _hasSuccessKey ? _successKeyValue : hasStatusCode2XX;
}

extension MapExtensions on Map {
  dynamic keyOf(dynamic value) {
    dynamic key;
    forEach((_key, _value) {
      if (_value == value) key = _key;
    });
    return key;
  }

  /// Iterate through the `values` of this map and
  /// returns a list of all non-null
  /// objects that are of the type `T`.
  List<T> getNonNullValues<T>() {
    List<T> result = [];
    for (final value in values) {
      if (value != null && value is T) {
        result.add(value);
      }
    }
    return result;
  }
}

extension ListExtensions on List<dynamic> {
  List<int> toIntList() => cast<int>();
  Uint8List toUint8List() => Uint8List.fromList(toIntList());
}

extension StringExtensions on String {
  List<int>? toIntList() {
    try {
      List list = jsonDecode(this);
      return list.cast<int>();
    } catch (e) {
      throw Exception("Can't convert String '$this' to a list of integers.");
    }
  }

  Uint8List? toUint8List() {
    final intList = toIntList();
    if (intList != null) {
      return Uint8List.fromList(intList);
    }
    return null;
  }

  String truncate(int length, {bool appendEllipsis = true}) {
    if (length < this.length) {
      final result = substring(0, length);
      return appendEllipsis ? "$result..." : result;
    } else {
      return this;
    }
  }

  String capitalizeFirstLetter() {
    String result = "";
    if (length > 0) {
      final firstLetter = substring(0, 1).toUpperCase();
      result = firstLetter + substring(1);
    }
    return result;
  }
}
