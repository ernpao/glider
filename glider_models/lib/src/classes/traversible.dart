abstract class Traversible {
  List<Traversible> get children;

  /// Apply [action] to all the leaves of this object.
  List<Future<T>> traverseChildren<T>(
      Future<T> Function(Traversible child) action);
  List<Future<T>> traverseToRoot<T>(
      Future<T> Function(Traversible ancestor) action);
}
