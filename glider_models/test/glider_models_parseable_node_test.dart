import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("Glider Models Parseable Node Test", () async {
    final root = ParseableNode();
    root.children = _createDummyChildren(5, 5);
    final parsed = ParseableNodeParser().parse(root.encode());

    assert(root.encode() == parsed.encode());

    final parsedDepth = parsed.getTotalDepth();
    final rootDepth = root.getTotalDepth();
    assert(parsedDepth == rootDepth);
  });
}

List<ParseableNode> _createDummyChildren(int count, depth) {
  List<ParseableNode> list = [];

  for (int i = 0; i < count; i++) {
    final node = ParseableNode();
    if (depth-- > 1) {
      node.children = _createDummyChildren(count, depth);
    }
    list.add(node);
  }

  return list;
}
