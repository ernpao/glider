import 'package:flutter/foundation.dart';

mixin Traverse {
  List<Traverse> get children;

  /// Apply [action] to all the leaves of this object.
  List<Future> traverseChildren(Future Function(Traverse child) action);
  List<Future> traverseToRoot(Future Function(Traverse ancestor) action);
}

abstract class Traversible extends AbstractNode with Traverse {
  @override
  final List<Traversible> children = [];

  @override
  List<Future> traverseChildren(Future Function(Traversible child) action) {
    final futures = <Future>[];
    for (var child in children) {
      futures.add(action(child));
      futures.addAll(child.traverseChildren(action));
    }
    return futures;
  }

  @override
  List<Future> traverseToRoot(Future Function(Traversible ancestor) action) {
    final futures = <Future>[];
    if (parent != null) {
      final ancestor = parent as Traversible;
      futures.add(action(ancestor));
      futures.addAll(ancestor.traverseToRoot(action));
    }
    return futures;
  }
}
