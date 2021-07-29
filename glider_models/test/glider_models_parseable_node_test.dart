import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  const int perGeneration = 5;
  const int generations = 5;
  final root = _createTree(perGeneration, generations);

  test("Glider Models Parseable Node - Traversal Test", () async {
    final futures = root.traverseChildren((child) async {
      final path = ''.padLeft(child.depth * 4) + child.identifier;
      debugPrintSynchronously(path);
      return path;
    });

    /// Calculate expected number of children
    int total = 0;
    for (var i = 0; i < generations; i++) {
      total += perGeneration * (pow(perGeneration, i).toInt());
    }

    assert(total == futures.length);
  });

  test("Glider Models Parseable Node - Parsing Test", () async {
    /// Test parsing
    final parsed = ParseableNodeParser().parse(root.encode());
    assert(root.encode() == parsed.encode());

    /// Test depth of parsed object
    final parsedDepth = parsed.getTotalDepth();
    final rootDepth = root.getTotalDepth();
    assert(parsedDepth == rootDepth);
  });
}

ParseableNode _createTree(int childrenPerGeneration, int generations) {
  final root = ParseableNode();
  root.identifier = "root";
  root.children = _createChildren(childrenPerGeneration, generations);
  return root;
}

List<ParseableNode> _createChildren(int count, depth) {
  List<ParseableNode> list = [];

  for (int i = 0; i < count; i++) {
    final node = ParseableNode();
    node.identifier = "$depth-${i + 1}";
    if (depth > 1) {
      node.children = _createChildren(count, depth - 1);
    }
    list.add(node);
  }

  return list;
}
