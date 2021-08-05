import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("Glider Models JSON Decode/Encode Test", () async {
    final testModel = _createTestModel();

    final parsed = JSON.parse(testModel.stringify());

    /// Test the `stringify` function
    final stringified = testModel.stringify();
    final parsedStringified = parsed.stringify();
    assert(parsedStringified == stringified);

    /// Test the `prettify` function
    final prettified = testModel.prettify();
    assert(JSON.parse(prettified).stringify() == stringified);

    /// Test array conversion
    final parsedItems = parsed.getProperty("items");
    final testModelItems = testModel.getProperty("items");
    assert(parsedItems is List && testModelItems is List);
    assert((parsedItems as List).length == (testModelItems as List).length);

    /// Test DateTime conversion
    final parsedCreatedType = parsed.getProperty("created").runtimeType;
    final testModelCreatedType = testModel.getProperty("created").runtimeType;
    assert(parsedCreatedType == testModelCreatedType);

    final KeyValueStore nested = parsed.getProperty("nested");
    final JSON nestedBody = nested["body"];
    final List nestedBodyItems = nestedBody.getProperty("items");
    assert(nested is KeyValueStore);
    assert(nestedBody is JSON);
    assert(nestedBodyItems is List);
  });
}

JSON _createTestModel() {
  final json = JSON();

  json.setProperty("name", "Test Model");
  json.setProperty("created", DateTime.now());

  final items = <JSON>[];
  for (int i = 0; i < 10; i++) {
    final content = JSON()
      ..setProperty("name", "Item $i Content")
      ..setProperty("body", "This is some sample text content for 'Item $i'.");

    items.add(
      JSON()
        ..setProperty("name", "Item $i")
        ..setProperty("content", content),
    );
  }

  json.setProperty("items", items);

  final body = JSON();
  body.setProperty("name", "body");
  body.setProperty("items", items);
  json.setProperty("body", body);

  final nestedMap = <String, dynamic>{
    "name": "Nested Map",
    "created": DateTime.now(),
    "body": body,
  };

  json.setProperty("nested", nestedMap);

  return json;
}
