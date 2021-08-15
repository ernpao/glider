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

  static List<Message> fromJsonArray(List<JSON> jsonArray) {
    return jsonArray.map((json) => Message(json)).toList();
  }

  static List<Message> fromWebResponse(WebResponse webResponse) {
    if (webResponse.isSuccessful) {
      assert(webResponse.httpResponse.decodedBody is List);
      return fromJsonArray(webResponse.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of Messages from an unsuccessful web request.",
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
