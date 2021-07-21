import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

extension ResponseExtensions on Response {
  dynamic get decodedBody => jsonDecode(body);
  Map<String, dynamic> get decodedBodyAsMap =>
      decodedBody as Map<String, dynamic>;
  bool get hasStatusCode2XX => statusCode.toString().startsWith("2");
  bool get hasStatusCode3XX => statusCode.toString().startsWith("3");
  bool get hasStatusCode4XX => statusCode.toString().startsWith("4");
  bool get hasStatusCode5XX => statusCode.toString().startsWith("5");
  bool get _hasSuccessKey => decodedBodyAsMap.keys.toList().contains("success");
  bool get _successKeyValue => decodedBodyAsMap["success"];
  bool get isSuccessful => _hasSuccessKey ? _successKeyValue : hasStatusCode2XX;
}

extension MapExtensions on Map {
  dynamic keyOf(dynamic value) {
    dynamic r;
    forEach((k, v) => (v == value) ? r = k : r);
    return r;
  }
}

extension ListExtensions on List<dynamic> {
  List<int> toIntList() => map((e) => e as int).toList();
  Uint8List toUint8List() => Uint8List.fromList(toIntList());
}

extension StringExtensions on String {
  List<int> toIntList() {
    List l = jsonDecode(this);
    return l.map((e) => e as int).toList();
  }

  Uint8List toUint8List() => Uint8List.fromList(toIntList());
}
