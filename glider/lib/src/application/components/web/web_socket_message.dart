import 'package:glider_models/glider_models.dart';

/// A JSON object with the following
/// predefined fields:
///
/// #### Sender
/// A string that is used to identify the sender of this [WebSocketMessage].
///
/// #### Category, Type, and Topic
/// String fields that can be used to describe payload of the message.
///
/// #### Body
/// A string that contains the payload of the message.
///
/// #### Created
/// Timestamp of when the [WebSocketMessage] was created.
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

  void _setSender(String sender) => set(kSender, sender);

  /// Indicates when this [WebSocketMessage] was created.
  DateTime? get created => DateTime.tryParse(get(kCreated));

  void _setCreated(DateTime created) {
    set(kCreated, created.toIso8601String());
  }

  /// Indicates if [category] is null.
  bool get hasCategory => contains(kCategory);
  String? get category => get<String>(kCategory);
  void setCategory(String? category) => set(kCategory, category);

  /// Indicates if [type] is null.
  bool get hasType => contains(kType);
  String? get type => get<String>(kType);
  void setType(String? type) => set(kType, type);

  /// Indicates if [topic] is null.
  bool get hasTopic => contains(kTopic);
  String? get topic => get<String>(kTopic);
  void setTopic(String? topic) => set(kTopic, topic);

  /// Indicates if [body] is null.
  bool get hasBody => contains(kBody);

  /// A [String] field that contains the payload of the message.
  String? get body => get<String>(kBody);
  void setBody(String? body) => set(kBody, body);

  /// Parse a [JSON] object into a [WebSocketMessage].
  static WebSocketMessage fromJson(JSON json) {
    final message = WebSocketMessage(
      sender: json.get<String>(kSender) ?? "Undefined",
      type: json.get<String>(kType),
      category: json.get<String>(kCategory),
      topic: json.get<String>(kTopic),
      body: json.get<String>(kBody),
    );

    /// Parse the timestamp of the message
    final timestamp = json.get<String>(kCreated);
    if (timestamp != null) {
      final dateTime = DateTime.tryParse(timestamp);
      if (dateTime != null) message._setCreated(dateTime);
    }
    return message;
  }

  static const _prefix = "_ws_";
  static const kSender = "${_prefix}sender";
  static const kType = "${_prefix}type";
  static const kCategory = "${_prefix}category";
  static const kTopic = "${_prefix}topic";
  static const kBody = "${_prefix}body";
  static const kCreated = "${_prefix}created";
}
