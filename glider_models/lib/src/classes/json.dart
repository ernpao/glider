import 'dart:convert';

import 'parseable.dart';
import 'stringifiable.dart';

class JSON extends Parseable implements Stringifiable {
  JSON({
    this.parseMap,
  });

  @override
  String stringify() => encode();

  String prettify() {
    return JsonEncoder.withIndent('  ', toEncodeable).convert(map());
  }

  @override
  Map<String, Type>? parseMap;
}

class JSONParser extends Parser<JSON> {
  @override
  JSON createParseableModel() => JSON();
}
