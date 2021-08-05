import 'package:glider_models/glider_models.dart';

import 'chat_room_user.dart';
import 'chat_user.dart';

abstract class ChatRoomModel {
  int get id;
  ChatUserModel get admin;
  List<ChatRoomUserModel> get people;
}

class ChatRoom implements ChatRoomModel {
  final JSON data;

  ChatRoom(this.data) {
    final jsonList = data.getListProperty<JSON>("people") ?? [];
    people = jsonList.map((json) => ChatRoomUser(json)).toList();
  }

  @override
  late final ChatUser admin = ChatUser(data.getProperty<JSON>("admin")!);

  @override
  late final int id = data.getProperty<int>("id")!;

  @override
  late final List<ChatRoomUser> people;
}
