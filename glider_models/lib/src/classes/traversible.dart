import 'package:flutter/foundation.dart';

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
