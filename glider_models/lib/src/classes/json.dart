import 'dart:convert';

import 'parseable.dart';
import 'stringifiable.dart';

class JSON extends Parseable implements Stringifiable {
  @override
  String stringify() => encode();

  String prettify() {
    return JsonEncoder.withIndent('  ', toEncodeable).convert(map());
  }
}

class JSONParser extends Parser<JSON> {
  @override
  JSON instantiateModel() => JSON();
}
