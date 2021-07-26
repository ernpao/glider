import 'traversible.dart';

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
