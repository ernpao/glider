import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'classes/mappable.dart';

extension ResponseExtensions on Response {
  dynamic get decodedBody => jsonDecode(body);
  KeyValueStore? get bodyAsMap {
    try {
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
    if (intList != null) Uint8List.fromList(intList);
  }
}
