import 'package:glider_models/glider_models.dart';

/// A [JSON] object with the following
/// predefined fields:
///
/// #### Sender
/// A [String] value that is used to identify the sender of this [WebSocketMessage].
///
/// #### Category, Type, and Topic
/// [String] fields that can be used to describe payload of the message.
///
/// #### Body
/// A [String] field that contains the payload of the message.
///
/// #### Created
/// A [DateTime] field that indicates when this [WebSocketMessage] was created.
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

  /// A [String] value that is used to identify the sender of this [WebSocketMessage].
  final String sender;
  void _setSender(String sender) => _set("sender", sender);

  /// Indicates when this [WebSocketMessage] was created.
  DateTime get created => DateTime.parse(_get("created"));
  void _setCreated(DateTime created) {
    _set("created", created.toIso8601String());
  }

  String? get category => _get("category");

  /// Indicates if [category] is null.
  bool get hasCategory => _contains("category");
  void setCategory(String? category) => _set("category", category);

  String? get type => _get("type");

  /// Indicates if [type] is null.
  bool get hasType => _contains("type");
  void setType(String? type) => _set("type", type);

  String? get topic => _get("topic");

  /// Indicates if [topic] is null.
  bool get hasTopic => _contains("topic");
  void setTopic(String? topic) => _set("topic", topic);

  /// A [String] field that contains the payload of the message.
  String? get body => _get("body");

  /// Indicates if [body] is null.
  bool get hasBody => _contains("body");
  void setBody(String? body) => _set("body", body);

  dynamic _get<T>(String key) => get<T>("$_prefix$key");
  void _set(String key, dynamic value) => set("$_prefix$key", value);
  bool _contains(String key) => contains("$_prefix$key");

  /// Parse a [JSON] object into a [WebSocketMessage].
  static WebSocketMessage fromJSON(JSON json) {
    /// Function for extracting values using keys
    /// with a predefined prefix
    String? _extract(String key) {
      return json.get("$_prefix$key")?.toString();
    }

    /// Extract the values from the `json`
    /// object provided
    final message = WebSocketMessage(
      sender: _extract("sender") ?? "Undefined",
      type: _extract("type"),
      category: _extract("category"),
      topic: _extract("topic"),
      body: _extract("body"),
    );

    /// Parse the timestamp of the message
    final timestamp = _extract("created");
    if (timestamp != null) {
      final dateTime = DateTime.tryParse(timestamp);
      if (dateTime != null) message._setCreated(dateTime);
    }
    return message;
  }

  static const String _prefix = "_ws_";
}
