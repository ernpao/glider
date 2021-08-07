import 'package:glider_models/glider_models.dart';

import 'chat_engine_user.dart';

abstract class MessageModel {
  int get id;
  ChatEngineUserModel get sender;
  DateTime get created;
  List get attachments;
  String get text;
}

class Message implements MessageModel {
  Message(this.data);

  final JSON data;

  static const _kCreated = "created";
  static const _kText = "text";
  static const _kSender = "sender";
  static const _kId = "id";
  static const _kAttachments = "attachments";

  @override
  DateTime get created =>
      DateTime.parse((data.getProperty<String>(_kCreated)!));

  @override
  String get text => data.getProperty<String>(_kText)!;

  @override
  ChatEngineUser get sender =>
      ChatEngineUser.fromMap(data.getProperty<KeyValueStore>(_kSender)!);

  @override
  int get id => data.getProperty<int>(_kId)!;

  @override
  List get attachments => data.getProperty(_kAttachments) ?? [];

  factory Message.parse(String string) => Message(JSON.parse(string));

  static List<Message> parseList(String string) =>
      JSON.parseList(string).map((json) => Message(json)).toList();
}
