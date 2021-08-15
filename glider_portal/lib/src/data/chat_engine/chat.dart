import 'package:glider/glider.dart';

import 'activity.dart';
import 'person.dart';
import 'message.dart';

abstract class ChatModel with Created {
  int get id;

  /// The admin of this chat.
  PersonModel get admin;

  /// A list of the activity
  /// of the people in this chat
  /// (i.e. their last read
  /// messages).
  ActivitiesModel get people;

  /// The title of this chat.
  String get title;

  /// Timestamp of when this chat was created.
  @override
  DateTime get created;

  /// The last message in this chat.
  Message get lastMessage;
}

typedef Chats = List<Chat>;

class Chat implements ChatModel {
  final JSON data;

  Chat(this.data) {
    final peopleMap = data.getListProperty<KeyValueStore>(_kPeople) ?? [];
    people = peopleMap.map((map) => Activity(JSON.fromMap(map))).toList();
  }

  static Chats fromJsonArray(List<JSON> jsonArray) {
    return jsonArray.map((json) => Chat(json)).toList();
  }

  static Chats chatsFromWebResponse(WebResponse webResponse) {
    if (webResponse.isSuccessful) {
      assert(webResponse.httpResponse.decodedBody is List);
      return fromJsonArray(webResponse.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of Chats from an unsuccessful web request.",
    );
  }

  @override
  late final Person admin = Person(
    JSON.fromMap(
      data.getProperty<KeyValueStore>(_kAdmin)!,
    ),
  );

  @override
  late final int id = data.getProperty<int>(_kId)!;

  @override
  late final Activities people;

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
