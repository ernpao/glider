import 'package:flutter/foundation.dart';

import 'parseable.dart';
import 'traversible.dart';

abstract class AbstractParseableNode extends Parseable
    with AbstractNode
    implements Traversible {
  @override
  List<AbstractParseableNode> get children;
  set children(covariant List<AbstractParseableNode> newChildren);

  String get identifier;
  set identifier(String id);

  String get path;

  List<AbstractParseableNode> getNodeWhere(
      bool Function(AbstractParseableNode node) test) {
    return children.where(test).toList();
  }

  List<AbstractParseableNode> getNodeByPath(String path) {
    return children.where((node) => node.path == path).toList();
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
}

class ParseableNode extends AbstractParseableNode {
  ParseableNode() {
    set(_childrenKey, <ParseableNode>[]);
  }

  static const String _childrenKey = "_parseableNodeChildren_";
  @override
  List<ParseableNode> get children => getListOf<ParseableNode>(_childrenKey);
  @override
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
    traverseChildren((node) async {
      if (node.depth > totalDepth) {
        totalDepth = node.depth;
      }
    });
    return totalDepth;
  }

  static const String _identifierKey = "_parseableNodeIdentifier_";
  @override
  String get identifier {
    final identifier = super.get<String>(_identifierKey);
    assert(identifier != null);
    return identifier!;
  }

  @override
  set identifier(String id) {
    assert(!id.contains(_pathSeparator), '''
        
        \n\nA node's identifier cannot contain the '$_pathSeparator' character since it is reserved for parsing the path of the node.

''');
    super.set(_identifierKey, id);
  }

  static const String _pathSeparator = "/";

  @override
  String get path {
    String _path = identifier;

    traverseToRoot((ancestor) async {
      _path = ancestor.identifier + _pathSeparator + _path;
    });

    return _path;
  }

  @override
  List<Future> traverseChildren(Future Function(ParseableNode child) action) {
    final futures = <Future>[];
    for (var child in children) {
      futures.add(action(child));
      futures.addAll(child.traverseChildren(action));
    }
    return futures;
  }

  @override
  List<Future> traverseToRoot(Future Function(ParseableNode ancestor) action) {
    final futures = <Future>[];
    if (parent != null) {
      final ancestor = parent as ParseableNode;
      futures.add(action(ancestor));
      futures.addAll(ancestor.traverseToRoot(action));
    }
    return futures;
  }
}

class ParseableNodeParser extends Parser<ParseableNode> {
  @override
  ParseableNode createModel() => ParseableNode();

  @override
  Map<String, Type>? get typeMap => {
        ParseableNode._childrenKey: List,
        ParseableNode._identifierKey: String,
      };
}
