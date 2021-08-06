import 'package:glider_models/glider_models.dart';

import 'chat_user.dart';
import 'chat_engine_user.dart';

abstract class ChatModel {
  int get id;
  ChatEngineUserModel get admin;
  List<ChatUserModel> get people;
  String get title;
  DateTime get created;
}

class Chat implements ChatModel {
  final JSON data;

  Chat(this.data) {
    final mapList = data.getListProperty<Map<String, dynamic>>("people") ?? [];
    people = mapList.map((map) => ChatRoomUser(JSON.fromMap(map))).toList();
  }

  @override
  late final ChatEngineUser admin =
      ChatEngineUser(data.getProperty<JSON>("admin")!);

  @override
  late final int id = data.getProperty<int>("id")!;

  @override
  late final List<ChatRoomUser> people;

  @override
  String get title => data.getProperty<String>("title")!;

  @override
  DateTime get created => data.getProperty<DateTime>("created")!;
}
