import 'package:flutter/foundation.dart';

class Node extends Traversible {
  @override
  void redepthChildren() {
    for (var child in children) {
      redepthChild(child);
    }
  }

  @override
  void attach(covariant Object owner) {
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

mixin Traverse {
  void traverse(Function(Traverse child) action);
}

abstract class Traversible extends AbstractNode with Traverse {
  final List<Traversible> children = [];

  @override
  void traverse(Function(Traversible child) action) {
    for (var child in children) {
      action(child);
      child.traverse(action);
    }
  }
}
