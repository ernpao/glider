import 'package:flutter/foundation.dart';

import 'parseable.dart';

import 'traversible.dart';

class Node extends Traversible {
  @override
  void redepthChildren() {
    for (var child in children) {
      redepthChild(child);
    }
  }

  @override
  void attach(covariant Node owner) {
    super.attach(owner);
    for (var child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    for (var child in children) {
      child.detach();
    }
    super.detach();
  }

  @override
  void adoptChild(Node child) {
    children.add(child);
    super.adoptChild(child);
  }

  @override
  void dropChild(Node child) {
    children.remove(child);
    super.dropChild(child);
  }
}

class ParseableNode extends Parseable with AbstractNode, Traverse {
  ParseableNode() {
    set(_childrenKey, <ParseableNode>[]);
  }

  static const String _childrenKey = "_parseableNodeChildren_";
  List<ParseableNode> get children => getListOf<ParseableNode>(_childrenKey);
  set children(List<ParseableNode> items) => set(_childrenKey, items);

  void _adoptChildren(List<ParseableNode> newChildren) {
    for (final child in newChildren) {
      adoptChild(child);
    }
  }

  @override
  void set(String key, dynamic value) {
    if (key == _childrenKey) {
      _adoptChildren((value as List).cast<ParseableNode>());
    }
    super.set(key, value);
  }

  int getTotalDepth() {
    int totalDepth = 0;
    traverse((node) {
      if (node.depth > totalDepth) {
        totalDepth = node.depth;
      }
    });
    return totalDepth;
  }

  @override
  void redepthChildren() {
    for (var child in children) {
      redepthChild(child);
    }
  }

  @override
  void attach(covariant ParseableNode owner) {
    super.attach(owner);
    for (var child in children) {
      child.attach(owner);
    }
  }

  @override
  void detach() {
    for (var child in children) {
      child.detach();
    }
    super.detach();
  }

  @override
  void adoptChild(covariant ParseableNode child) {
    super.adoptChild(child);
    children.add(child);
  }

  @override
  void dropChild(covariant ParseableNode child) {
    super.dropChild(child);
    children.remove(child);
  }

  @override
  void traverse(void Function(ParseableNode child) action) {
    for (var child in children) {
      action(child);
      child.traverse(action);
    }
  }
}

class ParseableNodeParser extends Parser<ParseableNode> {
  @override
  ParseableNode createModel() => ParseableNode();

  @override
  Map<String, Type>? get typeMap => {
        ParseableNode._childrenKey: List,
      };
}
