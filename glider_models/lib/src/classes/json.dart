import 'parseable.dart';

class JSON extends Parseable {}

class JSONParser extends Parser<JSON> {
  JSONParser({
    this.typeMap,
  });

  @override
  final Map<String, Type>? typeMap;

  @override
  JSON createModel() => JSON();
}
