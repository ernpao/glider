import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

import 'chat_user.dart';

abstract class ChatMessageModel {
  int get id;
  ChatUserModel get sender;
  DateTime get created;
  List get attachments;
  String get text;
}

class ChatMessage extends Parseable with ChatMessageModel {
  ChatMessage._();

  static const String _kCreated = "created";
  static const String _kText = "text";
  static const String _kSender = "sender";
  static const String _kId = "id";
  static const String _kAttachments = "attachments";

  @override
  DateTime get created => DateTime.parse((super.get<String>(_kCreated)!));

  @override
  String get text => super.get<String>(_kText)!;

  @override
  ChatUser get sender => ChatUser.fromMap(super.get<KeyValueStore>(_kSender)!);

  static final _MessageParser _parser = _MessageParser();

  @override
  int get id => super.get<int>(_kId)!;

  @override
  List get attachments => super.getListOf(_kAttachments)!;

  factory ChatMessage.parse(String string) => _parser.parse(string);
}

class _MessageParser extends Parser<ChatMessage> {
  @protected
  @override
  ChatMessage createModel() => ChatMessage._();

  @override
  Map<String, Type?>? get typeMap => {
        ChatMessage._kCreated: String,
        ChatMessage._kText: String,
        ChatMessage._kSender: null,
        ChatMessage._kId: int,
        ChatMessage._kAttachments: List,
      };
}
