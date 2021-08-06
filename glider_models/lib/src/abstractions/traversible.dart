abstract class Traversible {
  /// The direct descendants of this [Traversible] object.
  List<Traversible> get children;

  /// The ancestor of this [Traversible] object.
  Traversible? get ancestor;

  /// Apply [action] to all the leaves of this [Traversible] object.
  ///
  /// This will also cast all children as [T], which should be a
  /// superclass of [Traversible].
  void traverseChildrenAs<T extends Traversible>(Function(T child) action) {
    Traversible.traverseChildrenOfRootAs<T>(this as T, action);
  }

  /// Apply [action] to all the ancestors of this [Traversible] object.
  ///
  /// This will also cast all ancestors found as [T], which should be a
  /// superclass of [Traversible].
  void traverseAncestorsAs<T extends Traversible>(Function(T ancestor) action) {
    Traversible.traverseAncestorsFromChildAs<T>(this as T, action);
  }

  static void traverseChildrenOfRootAs<T extends Traversible>(
    T root,
    Function(T child) action,
  ) {
    for (var child in root.children) {
      action(child as T);
      child.traverseChildrenAs((c) => action(c as T));
    }
  }

  static void traverseAncestorsFromChildAs<T extends Traversible>(
    T child,
    Function(T ancestor) action,
  ) {
    final ancestor = child.ancestor;
    if (ancestor != null) {
      action(ancestor as T);
      ancestor.traverseAncestorsAs((a) => action(a as T));
    }
  }
}
