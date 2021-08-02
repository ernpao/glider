import 'parseable.dart';

class JSON extends Parseable {
  JSON();

  /// Create a new `JSON` object by parsing a string.
  factory JSON.parse(String string) => _parser.parse(string);

  static final _parser = _JSONParser();
}

class _JSONParser extends Parser<JSON> {
  _JSONParser({
    this.typeMap,
  });

  @override
  final Map<String, Type>? typeMap;

  @override
  JSON createModel() => JSON();
}
