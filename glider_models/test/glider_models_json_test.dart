import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("JSON Decode/Encode Test", () async {
    final testModel = _createTestModel();

    final parsed = JSONParser().parse(testModel.stringify());

    /// Test the `stringify` function
    final stringified = testModel.stringify();
    final parsedStringified = parsed.stringify();
    assert(parsedStringified == stringified);

    /// Test the `prettify` function
    final prettified = testModel.prettify();
    assert(JSONParser().parse(prettified).stringify() == stringified);

    /// Test array conversion
    final parsedItems = parsed.get("items");
    final testModelItems = testModel.get("items");
    assert(parsedItems is List && testModelItems is List);
    assert((parsedItems as List).length == (testModelItems as List).length);

    /// Test DateTime conversion
    final parsedCreatedType = parsed.get("created").runtimeType;
    final testModelCreatedType = testModel.get("created").runtimeType;
    assert(parsedCreatedType == testModelCreatedType);

    final nested = parsed.get("nested");
    final nestedBody = nested.get("body");
    final nestedBodyItems = nestedBody.get("items");
    assert(nested is JSON);
    assert(nestedBody is JSON);
    assert(nestedBodyItems is List);
  });
}

JSON _createTestModel() {
  final json = JSON();

  json.set("name", "Test Model");
  json.set("created", DateTime.now());

  final items = <JSON>[];
  for (int i = 0; i < 10; i++) {
    final content = JSON()
      ..set("name", "Item $i Content")
      ..set("body", "This is some sample text content for 'Item $i'.");

    items.add(
      JSON()..set("name", "Item $i")..set("content", content),
    );
  }

  json.set("items", items);

  final body = JSON();
  body.set("name", "body");
  body.set("items", items);
  json.set("body", body);

  final nestedMap = <String, dynamic>{
    "name": "Nested Map",
    "created": DateTime.now(),
    "body": body,
  };

  json.set("nested", nestedMap);

  return json;
}
