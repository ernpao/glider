import 'package:glider_models/glider_models.dart';

class WebSocketMessage extends JSON {
  WebSocketMessage({
    required this.sender,
    String? category,
    String? type,
    String? topic,
    String? body,
  }) {
    _setSender(sender);
    setType(type);
    setCategory(category);
    setTopic(topic);
    setBody(body);
    _setCreated(DateTime.now());
  }

  final String sender;
  void _setSender(String sender) => _set("sender", sender);

  DateTime get created => DateTime.parse(_get("created"));
  void _setCreated(DateTime created) {
    _set("created", created.toIso8601String());
  }

  String? get category => _get("category");
  bool get hasCategory => _contains("category");
  void setCategory(String? category) => _set("category", category);

  String? get type => _get("type");
  bool get hasType => _contains("type");
  void setType(String? type) => _set("type", type);

  String? get topic => _get("topic");
  bool get hasTopic => _contains("topic");
  void setTopic(String? topic) => _set("topic", topic);

  String? get body => _get("body");
  bool get hasBody => _contains("body");
  void setBody(String? body) => _set("body", body);

  dynamic _get<T>(String key) => get<T>("$_prefix$key");
  void _set(String key, dynamic value) => set("$_prefix$key", value);
  bool _contains(String key) => contains("$_prefix$key");

  static WebSocketMessage fromJSON(JSON json) {
    String? _extract(String key) => json.content["$_prefix$key"];
    return WebSocketMessage(
      sender: _extract("sender")!,
      type: _extract("type"),
      category: _extract("category"),
      topic: _extract("topic"),
      body: _extract("body"),
    ).._setCreated(DateTime.parse(_extract("created").toString()));
  }

  static const String _prefix = "_ws_";
}
