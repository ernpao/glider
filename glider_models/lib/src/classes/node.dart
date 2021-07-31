import 'package:flutter/foundation.dart';

import 'parseable.dart';
import 'traversible.dart';

class Node extends AbstractNode with Traversible {
  Node({required this.identifier});

  /// A string identifier for this node.
  ///
  /// Used for determining the path
  /// of this node.
  final String identifier;

  @override
  final List<Node> children = [];

  /// The complete path of this node from the root node.
  String get path => getPathOfNode(this);

  /// Get the complete path of this node from the root node.
  static String getPathOfNode(Node node) {
    String p = node.identifier;
    node.traverseAncestorsAs<Node>((n) => p = n.identifier + pathSeparator + p);
    return p;
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

  int get totalDepth => calculateNodeDepth(this);

  static int calculateNodeDepth(Node node) {
    int d = 0;
    node.traverseChildrenAs<Node>((n) => d = n.depth > d ? n.depth : d);
    return d;
  }

  @override
  Node? get ancestor => getAncestorOfNodeAs<Node>(this);

  static T? getAncestorOfNodeAs<T extends Traversible>(Node node) {
    final ancestor = node.parent;
    if (ancestor != null) {
      return ancestor as T;
    }
    return null;
  }

  /// Get the node directly below this node with
  /// the same identifier as [id];
  Node? getChildById(String id) => getChildOfParentById(this, id);

  /// Get the node directly below the [parent] with
  /// the same identifier as [id];
  static Node? getChildOfParentById(Node parent, String id) {
    final nodes = parent.children.where((n) => n.identifier == id).toList();

    if (nodes.length > 1) {
      throw Exception(
        "More than one node was found with the identifier '$id'.",
      );
    }

    if (nodes.isEmpty) return null;
    return nodes.first;
  }

  /// Get the node below this node at the specified path.
  ///
  /// This will throw an error if it is found
  /// that multiple nodes exist with the same path.
  Node? getNode(String path) => getNodeByPath(this, path);

  /// Get the node below [baseNode] at the specified path. [isRelative]
  /// indicates if [path] is relative to the path of [baseNode] and is set
  /// to false by default.
  static Node? getNodeByPath(Node baseNode, String path) {
    {
      isPathValid(path, throwException: true);

      final _path = _isPathRelative(path) ? baseNode.identifier + path : path;
      final nodes = baseNode.children.where((c) {
        final p = c.path;
        return p == _path;
      }).toList();

      if (nodes.length > 1) {
        throw Exception("More than one node was found at '$path'.");
      }

      if (nodes.isEmpty) return null;
      return nodes.first;
    }
  }

  /// Sets a child node at the specified path.
  ///
  /// This will replace the node if the parent
  /// specified already contains
  /// a child node with the same identifier as [child].
  void setNode(String path, covariant Node child) {
    setNodeByPath(this, path, child);
  }

  static void setNodeByPath(Node baseNode, String path, Node child) {
    String fullPath = _isPathRelative(path) ? baseNode.path + path : path;
    isPathValid(fullPath, throwException: true);

    final first = fullPath.indexOf(pathSeparator);
    final start = first != -1 ? first : 0;

    final last = fullPath.lastIndexOf(pathSeparator);
    final end = last != -1 ? last : null;

    final bridgePath = fullPath.substring(start, end);

    Node nodeToAddChildTo;
    if (bridgePath.isEmpty && baseNode.parent == null) {
      nodeToAddChildTo = baseNode;
    } else {
      final lastNode = baseNode.getNode(bridgePath);
      if (lastNode == null) {
        throw Exception(
          "Cannot create a node at the specified path '$path' since there are missing nodes from the base node to this path.",
        );
      }
      nodeToAddChildTo = lastNode;
    }

    nodeToAddChildTo.children.removeWhere((n) => n.path == fullPath);
    nodeToAddChildTo.adoptChild(child);
  }

  /// Tests if [path] is a path to a node relative to a given node
  /// (i.e. starts with the separator character `/`).
  ///
  /// Examples of relative paths:
  ///
  /// ```dart
  /// "/target"
  /// "/node1/node2/target"
  /// ```
  static bool _isPathRelative(String path) => path.startsWith(pathSeparator);

  /// Tests if the format of [path] is valid.
  ///
  /// [path] should not end with the separator character `/`. [path]
  /// should also not start with `/` if
  /// the optional parameter [isRelative] is not set to true. It
  /// should also not contain consecutive separators.
  ///
  /// This will also throw an exception if [throwException] is
  /// set to true and if the path is found to be invalid.
  ///
  /// Examples of valid paths:
  ///
  /// ```dart
  /// "/target"
  /// "/node1/node2/target"
  /// "target"
  /// ```
  ///
  /// Examples of invalid paths:
  ///
  /// ```dart
  /// "target/"
  /// "node//node"
  /// "./node"
  /// "./"
  /// "../"
  /// ```
  static bool isPathValid(String path, {bool throwException = false}) {
    final isValid = !path.endsWith(pathSeparator) &&
        !path.contains("$pathSeparator$pathSeparator") &&
        !path.startsWith(".");

    if (!isValid && throwException) {
      throw Exception("'$path' is not  a valid path.");
    }

    return isValid;
  }

  static const String pathSeparator = "/";
}

abstract class ParseableNode extends Parseable
    with AbstractNode
    implements Node {
  ParseableNode() {
    set(_childrenKey, <ParseableNode>[]);
  }

  static const String _childrenKey = "__children";
  static const String _identifierKey = "__id";

  @override
  void set(String key, dynamic value) {
    if (key == _childrenKey) {
      bool throwException = value is! List;

      var list = value as List;
      var nodes = <ParseableNode>[];

      if (list.isNotEmpty && !throwException) {
        final first = list.first;
        if (first is Map<String, dynamic>) {
          var castedList = list.cast<Map<String, dynamic>>();

          for (final item in castedList) {
            final node = childParser.parseFromMap(item);
            nodes.add(node);
          }
        } else if (first is ParseableNode) {
          var castedList = list.cast<ParseableNode>();
          for (final item in castedList) {
            final node = childParser.translate<ParseableNode>(item);
            nodes.add(node);
          }
        } else {
          throwException = true;
        }
      }

      if (throwException) {
        throw Exception(
          "Invalid value: Attempted to set ${value.runtimeType.toString()} as children of node $identifier."
          "The children of a node must be a list of Node or Map<String, dynamic> that conforms to the parseMap "
          "of this node's childParser.",
        );
      }

      _adoptNodes(nodes);
      return super.set(key, nodes);
    }

    /// Use default behavior if children of node is not being set.
    super.set(key, value);
  }

  /// The parser for the children of this node.
  ///
  /// This enables nodes to have children that are of a different class
  /// than themselves (as long as they extend [ParseableNode]) simply
  /// by setting [childParser] as a [NodeParser] for the same type
  /// as the children.
  NodeParser get childParser;

  @override
  List<ParseableNode> get children => getListOf<ParseableNode>(_childrenKey);

  /// Replace all the children of this node with [items].
  set children(List<ParseableNode> items) => set(_childrenKey, items);

  /// Adopt a list of [ParseableNode].
  void _adoptNodes(List<ParseableNode> nodes) => nodes.forEach(adoptChild);

  @override
  String get identifier {
    final id = super.get<String>(_identifierKey) ?? "";
    if (id.isEmpty) {
      throw Exception("The identifier for this node has not been set.");
    }
    return id;
  }

  /// Sets the [identifier] for this node.
  set identifier(String id) {
    if (id.isEmpty) {
      throw Exception("A node's identifier cannot be empty.");
    }

    if (id.contains(_separator)) {
      throw Exception(
        "A node's identifier cannot contain the '$_separator' character since it is reserved for parsing the path of the node.",
      );
    }

    super.set(_identifierKey, id);
  }

  /// Applies [action] to all the nodes below this node.
  @override
  void traverseChildrenAs<T extends Traversible>(Function(T child) action) {
    Traversible.traverseChildrenOfRootAs<T>(this as T, action);
  }

  @override
  void traverseAncestorsAs<T extends Traversible>(Function(T ancestor) action) {
    Traversible.traverseAncestorsFromChildAs<T>(this as T, action);
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

  static const String _separator = Node.pathSeparator;

  @override
  String get path => Node.getPathOfNode(this);

  @override
  int get totalDepth => Node.calculateNodeDepth(this);

  @override
  ParseableNode? getChildById(String id) {
    Node.getChildOfParentById(this, id) as ParseableNode;
  }

  @override
  ParseableNode? get ancestor => Node.getAncestorOfNodeAs<ParseableNode>(this);

  @override
  Node? getNode(String path) => Node.getNodeByPath(this, path);

  @override
  void setNode(String path, ParseableNode child) {
    Node.setNodeByPath(this, path, child);
  }
}

abstract class NodeParser<T extends ParseableNode> extends Parser<T> {
  Map<String, Type>? get nodeMap;

  @override
  Map<String, Type>? get typeMap {
    final baseMap = {
      ParseableNode._childrenKey: List,
      ParseableNode._identifierKey: String,
    };
    return baseMap..addAll(nodeMap ?? {});
  }
}
