import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glider_models/glider_models.dart';

void main() {
  test("Glider Models Parseable Node - Traversal Test", () async {
    int count = 0;

    root.traverseChildrenAs<SampleNode>((child) {
      final paddedId = ''.padLeft(child.depth * 4) + child.identifier;
      debugPrintSynchronously(paddedId);
      count++;
      return paddedId;
    });

    /// Calculate expected number of children
    int total = 0;
    for (var i = 0; i < generations; i++) {
      total += perGeneration * (pow(perGeneration, i).toInt());
    }

    assert(total == count);
  });

  test("Glider Models Parseable Node - Parsing Test", () async {
    assert(root.totalDepth == generations);

    /// Test parsing
    final parsed = SampleNodeParser().parse(root.encode());
    assert(root.encode() == parsed.encode());

    /// Test depth of parsed object
    final parsedDepth = parsed.totalDepth;
    final rootDepth = root.totalDepth;
    assert(parsedDepth == rootDepth);
  });

  test("Glider Models Parseable Node - getNode Test", () async {
    assert(root.path == "root");

    final node = root.getNode("root/5-1");
    assert(node != null);
    assert(node!.path == "root/5-1");
    assert(node!.identifier == "5-1");
    assert((node!.parent as SampleNode).identifier == "root");
  });

  test("Glider Models Parseable Node - setNode Test", () async {
    const newNodeId = "Test Node";
    final newNode = SampleNode()..identifier = newNodeId;
    final childCount = root.children.length;

    expect(() {
      root.setNode("/test/asdasd", newNode);
    }, throwsException);

    root.setNode("/test", newNode);
    assert(newNode.ancestor!.path == "root");
    assert(root.children.length == childCount + 1);
  });

  test("Glider Models Parseable Node - Node Path Test", () async {
    /// Test valid path detection
    assert(Node.isPathValid("target") == true);
    assert(Node.isPathValid("node1/node2/target") == true);
    assert(Node.isPathValid("/target") == true);

    /// Test invalid path detection
    assert(Node.isPathValid("/target/") == false);
    assert(Node.isPathValid("target/") == false);
    assert(Node.isPathValid("node//node") == false);
    assert(Node.isPathValid("./") == false);
  });
}

const int perGeneration = 5;
const int generations = 5;
final root = _createTree(perGeneration, generations);

class SampleNodeParser extends NodeParser<SampleNode> {
  @override
  SampleNode createModel() => SampleNode();
  @override
  Map<String, Type>? get nodeMap => null;
}

class SampleNode extends ParseableNode {
  @override
  SampleNodeParser get childParser => SampleNodeParser();
}

SampleNode _createTree(int childrenPerGeneration, int generations) {
  final root = SampleNode();
  root.identifier = "root";
  root.children = _createChildren(childrenPerGeneration, generations);
  return root;
}

List<SampleNode> _createChildren(int count, depth) {
  List<SampleNode> list = [];

  for (int i = 0; i < count; i++) {
    final node = SampleNode();
    node.identifier = "$depth-${i + 1}";
    if (depth > 1) {
      node.children = _createChildren(count, depth - 1);
    }
    list.add(node);
  }

  return list;
}
