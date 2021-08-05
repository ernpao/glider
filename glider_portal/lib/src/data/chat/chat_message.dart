import 'package:glider_models/glider_models.dart';

import 'chat_user.dart';

abstract class ChatMessageModel {
  int get id;
  ChatUserModel get sender;
  DateTime get created;
  List get attachments;
  String get text;
}

class ChatMessage implements ChatMessageModel {
  ChatMessage(this.data);

  final JSON data;

  static const String _kCreated = "created";
  static const String _kText = "text";
  static const String _kSender = "sender";
  static const String _kId = "id";
  static const String _kAttachments = "attachments";

  @override
  DateTime get created =>
      DateTime.parse((data.getProperty<String>(_kCreated)!));

  @override
  String get text => data.getProperty<String>(_kText)!;

  @override
  ChatUser get sender =>
      ChatUser.fromMap(data.getProperty<KeyValueStore>(_kSender)!);

  @override
  int get id => data.getProperty<int>(_kId)!;

  @override
  List get attachments => data.getProperty(_kAttachments) ?? [];

  factory ChatMessage.parse(String string) => ChatMessage(JSON.parse(string));

  static List<ChatMessage> parseList(String string) =>
      JSON.parseList(string).map((json) => ChatMessage(json)).toList();
}
