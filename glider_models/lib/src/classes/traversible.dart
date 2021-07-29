import 'package:flutter/foundation.dart';

abstract class Traversible {
  List<Traversible> get children;

  /// Apply [action] to all the leaves of this object.
  List<Future> traverseChildren(Future Function(Traversible child) action);
  List<Future> traverseToRoot(Future Function(Traversible ancestor) action);
}

abstract class TraversibleNode extends AbstractNode with Traversible {
  @override
  final List<TraversibleNode> children = [];

  @override
  List<Future> traverseChildren(Future Function(TraversibleNode child) action) {
    final futures = <Future>[];
    for (var child in children) {
      futures.add(action(child));
      futures.addAll(child.traverseChildren(action));
    }
    return futures;
  }

  @override
  List<Future> traverseToRoot(
      Future Function(TraversibleNode ancestor) action) {
    final futures = <Future>[];
    if (parent != null) {
      final ancestor = parent as TraversibleNode;
      futures.add(action(ancestor));
      futures.addAll(ancestor.traverseToRoot(action));
    }
    return futures;
  }

  @override
  void redepthChildren() {
    for (var child in children) {
      redepthChild(child);
    }
  }

  @override
  void attach(covariant TraversibleNode owner) {
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
  void adoptChild(TraversibleNode child) {
    children.add(child);
    super.adoptChild(child);
  }

  @override
  void dropChild(TraversibleNode child) {
    children.remove(child);
    super.dropChild(child);
  }
}
