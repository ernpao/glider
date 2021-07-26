import 'dart:convert';

import 'parseable.dart';
import 'stringifiable.dart';

class JSON extends Parseable implements Stringifiable {
  @override
  String stringify() => encode();

  String prettify() =>
      JsonEncoder.withIndent('  ', toEncodeable).convert(map());

  static JSON parse(String jsonString) {
    final parseable = Parseable.parse(jsonString);

    parseable.forEach((key, value) {
      if (value is Parseable) {
        parseable.set(key, JSON.parse(value.encode()));
      }
    });

    return Parseable.copyTo<JSON>(parseable, JSON());
  }
}
