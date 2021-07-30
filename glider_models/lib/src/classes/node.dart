import 'package:flutter/foundation.dart';

import 'parseable.dart';
import 'traversible.dart';

abstract class Node extends AbstractNode with Traversible {
  @override
  final List<Node> children = [];

  @override
  List<Future<T>> traverseChildren<T>(Future<T> Function(Node child) action) {
    final futures = <Future<T>>[];
    for (var child in children) {
      futures.add(action(child));
      futures.addAll(child.traverseChildren(action));
    }
    return futures;
  }

  @override
  List<Future<T>> traverseToRoot<T>(Future<T> Function(Node ancestor) action) {
    final futures = <Future<T>>[];
    if (parent != null) {
      final ancestor = parent as Node;
      futures.add(action(ancestor));
      futures.addAll(ancestor.traverseToRoot(action));
    }
    return futures;
  }

  @override
  void redepthChildren() => children.forEach(redepthChild);

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

  int get totalDepth {
    int d = 0;
    traverseChildren<int>((n) async => d = n.depth > d ? n.depth : d);
    return d;
  }
}

abstract class PathableNode {
  String get path;

  /// A string identifier for this node. Used for determining the path
  /// of this node.
  String get identifier;

  Node getNodeByPath(String path);
}

class ParseableNode extends Parseable
    with AbstractNode
    implements Node, PathableNode {
  ParseableNode() {
    set(_childrenKey, <ParseableNode>[]);
  }

  static const String _childrenKey = "_parseableNodeChildren_";

  @override
  List<ParseableNode> get children => getListOf<ParseableNode>(_childrenKey);

  set children(List<ParseableNode> items) => set(_childrenKey, items);

  /// Adopt a list of [ParseableNode].
  void _adoptNodes(List<ParseableNode> nodes) => nodes.forEach(adoptChild);

  @override
  void set(String key, dynamic value) {
    if (key == _childrenKey) {
      _adoptNodes((value as List).cast<ParseableNode>());
    }
    super.set(key, value);
  }

  static const String _identifierKey = "_parseableNodeIdentifier_";

  @override
  String get identifier {
    final identifier = super.get<String>(_identifierKey);
    assert(identifier != null);
    return identifier!;
  }

  set identifier(String id) {
    assert(!id.contains(_pathSeparator), '''
        
        \n\nA node's identifier cannot contain the '$_pathSeparator' character since it is reserved for parsing the path of the node.

''');
    super.set(_identifierKey, id);
  }

  @override
  List<Future<T>> traverseChildren<T>(
      Future<T> Function(ParseableNode child) action) {
    final futures = <Future<T>>[];
    for (var child in children) {
      futures.add(action(child));
      futures.addAll(child.traverseChildren(action));
    }
    return futures;
  }

  @override
  List<Future<T>> traverseToRoot<T>(
      Future<T> Function(ParseableNode ancestor) action) {
    final futures = <Future<T>>[];
    if (parent != null) {
      final ancestor = parent as ParseableNode;
      futures.add(action(ancestor));
      futures.addAll(ancestor.traverseToRoot(action));
    }
    return futures;
  }

  @override
  void redepthChildren() => children.forEach(redepthChild);

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
  void adoptChild(ParseableNode child) {
    children.add(child);
    super.adoptChild(child);
  }

  @override
  void dropChild(ParseableNode child) {
    children.remove(child);
    super.dropChild(child);
  }

  static const String _pathSeparator = "/";

  @override
  String get path {
    String _path = identifier;

    traverseToRoot(
        (node) async => _path = node.identifier + _pathSeparator + _path);

    return _path;
  }

  @override
  ParseableNode getNodeByPath(String path) {
    final nodes = children.where((child) => child.path == path).toList();
    assert(nodes.length == 1, '''
        
        \n\nMore than one node was found at '$path'.

''');
    return nodes.first;
  }

  @override
  int get totalDepth {
    int d = 0;
    traverseChildren<int>((n) async => d = n.depth > d ? n.depth : d);
    return d;
  }
}

class ParseableNodeParser extends Parser<ParseableNode> {
  @override
  ParseableNode createModel() => ParseableNode();

  @override
  Map<String, Type>? get typeMap {
    return {
      ParseableNode._childrenKey: List,
      ParseableNode._identifierKey: String,
    };
  }
}
