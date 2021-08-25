import 'package:glider/glider.dart';

import 'person.dart';

abstract class MessageModel {
  int get id;
  PersonModel get sender;
  DateTime? get created;
  List get attachments;
  String get text;
}

typedef Messages = List<Message>;

class Message implements MessageModel {
  Message(this.data);

  final JSON data;

  static Messages fromJsonArray(List<JSON> jsonArray) {
    return jsonArray.map((json) => Message(json)).toList();
  }

  static Messages messagesFromWebResponse(WebResponse response) {
    if (response.isSuccessful) {
      assert(response.httpResponse.decodedBody is List);
      return fromJsonArray(response.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of Message from an unsuccessful web request.",
    );
  }

  static const _kCreated = "created";
  static const _kText = "text";
  static const _kSender = "sender";
  static const _kId = "id";
  static const _kAttachments = "attachments";

  @override
  DateTime? get created {
    String timestamp = data.getProperty<String>(_kCreated)!;
    timestamp = timestamp.split("+")[0];
    return DateTime.tryParse(timestamp);
  }

  @override
  String get text => data.getProperty<String>(_kText)!;

  @override
  Person get sender =>
      Person.fromMap(data.getProperty<KeyValueStore>(_kSender)!);

  @override
  int get id => data.getProperty<int>(_kId)!;

  @override
  List get attachments => data.getProperty(_kAttachments) ?? [];

  factory Message.parse(String string) => Message(JSON.parse(string));

  static List<Message> parseList(String string) =>
      JSON.parseList(string).map((json) => Message(json)).toList();
}

/// Represents a placeholder message.
class DummyMessage implements MessageModel {
  DummyMessage({
    required String text,
    required Person sender,
    List attachments = const [],
  }) {
    _created = DateTime.now();
    _text = text;
    _sender = sender;
    _attachments = attachments;
  }

  late final DateTime? _created;
  late final String _text;
  late final Person _sender;
  late final List _attachments;

  @override
  List get attachments => _attachments;

  @override
  DateTime? get created => _created;

  @override
  int get id => -1;

  @override
  Person get sender => _sender;

  @override
  String get text => _text;
}
