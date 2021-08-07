import 'package:glider/glider.dart';

import 'chat_user.dart';
import 'chat_engine_user.dart';
import 'message.dart';

abstract class ChatModel {
  int get id;
  ChatEngineUserModel get admin;
  List<ChatUserModel> get people;
  String get title;
  DateTime get created;
  Message get lastMessage;
}

class Chat implements ChatModel {
  final JSON data;

  Chat(this.data) {
    final mapList = data.getListProperty<Map<String, dynamic>>(_kPeople) ?? [];
    people = mapList.map((map) => ChatRoomUser(JSON.fromMap(map))).toList();
  }

  static List<Chat> fromJsonArray(List<JSON> jsonArray) {
    return jsonArray.map((json) => Chat(json)).toList();
  }

  static List<Chat> fromWebResponse(WebResponse webResponse) {
    if (webResponse.isSuccessful) {
      assert(webResponse.httpResponse.decodedBody is List);
      return fromJsonArray(webResponse.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of Chats from an unsuccessful web request.",
    );
  }

  @override
  late final ChatEngineUser admin = ChatEngineUser(
    JSON.fromMap(
      data.getProperty<KeyValueStore>(_kAdmin)!,
    ),
  );

  @override
  late final int id = data.getProperty<int>(_kId)!;

  @override
  late final List<ChatRoomUser> people;

  @override
  String get title => data.getProperty<String>(_kTitle)!;

  @override
  DateTime get created => data.getProperty<DateTime>(_kCreated)!;

  @override
  late final Message lastMessage = Message(
    JSON.fromMap(
      data.getProperty<KeyValueStore>(_kLastMessage)!,
    ),
  );

  static const _kAdmin = "admin";
  static const _kId = "id";
  static const _kTitle = "title";
  static const _kCreated = "created";
  static const _kPeople = "people";
  static const _kLastMessage = "last_message";
}
