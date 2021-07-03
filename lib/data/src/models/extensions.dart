import 'dart:convert';

import 'package:http/http.dart';

extension ResponseExtensions on Response {
  dynamic get decodedBody => jsonDecode(body);
  Map<String, dynamic> get decodedBodyAsJson =>
      decodedBody as Map<String, dynamic>;
  bool get hasStatusCode2XX => statusCode.toString().startsWith("2");
  bool get hasStatusCode3XX => statusCode.toString().startsWith("3");
  bool get hasStatusCode4XX => statusCode.toString().startsWith("4");
  bool get hasStatusCode5XX => statusCode.toString().startsWith("5");
  bool get hasSuccessKey => decodedBodyAsJson.keys.toList().contains("success");
  bool get successKeyValue => decodedBodyAsJson["success"];
  bool get isSuccessful => hasSuccessKey ? successKeyValue : hasStatusCode2XX;
}

extension MapExtensions on Map {
  dynamic keyOf(dynamic value) {
    dynamic s;
    this.forEach((k, v) => (v == value) ? s = k : s);
    return s;
  }
}
