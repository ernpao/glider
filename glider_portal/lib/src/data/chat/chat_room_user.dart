import 'package:glider_models/glider_models.dart';

import 'chat_user.dart';

abstract class ChatRoomUserModel {
  ChatUserModel get person;
  int get lastRead;
}

class ChatRoomUser implements ChatRoomUserModel {
  ChatRoomUser(this.data);

  final JSON data;

  @override
  int get lastRead => data.getProperty<int>(_kLastRead)!;

  @override
  ChatUser get person =>
      ChatUser.fromMap(data.getProperty<KeyValueStore>(_kPerson)!);

  factory ChatRoomUser.parse(String string) => ChatRoomUser(JSON.parse(string));

  static List<ChatRoomUser> parseList(String string) =>
      fromJsonList(JSON.parseList(string));

  static List<ChatRoomUser> fromJsonList(List<JSON> jsonArray) =>
      jsonArray.map((json) => ChatRoomUser(json)).toList();

  static const String _kPerson = "person";
  static const String _kLastRead = "last_read";
}
