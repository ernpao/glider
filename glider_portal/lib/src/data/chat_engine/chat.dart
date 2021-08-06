import 'package:glider_models/glider_models.dart';

import 'chat_user.dart';
import 'chat_engine_user.dart';

abstract class ChatModel {
  int get id;
  ChatEngineUserModel get admin;
  List<ChatUserModel> get people;
}

class Chat implements ChatModel {
  final JSON data;

  Chat(this.data) {
    final jsonList = data.getListProperty<JSON>("people") ?? [];
    people = jsonList.map((json) => ChatRoomUser(json)).toList();
  }

  @override
  late final ChatEngineUser admin =
      ChatEngineUser(data.getProperty<JSON>("admin")!);

  @override
  late final int id = data.getProperty<int>("id")!;

  @override
  late final List<ChatRoomUser> people;
}
