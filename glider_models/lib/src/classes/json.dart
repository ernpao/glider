import 'parseable.dart';
import 'stringifiable.dart';

class JSON extends Parseable implements Stringifiable {
  @override
  String stringify() => encode();
}

class JSONParser extends Parser<JSON> {
  JSONParser({
    this.typeMap,
  });

  @override
  final Map<String, Type>? typeMap;

  @override
  JSON createModel() => JSON();
}
