import 'package:glider_models/glider_models.dart';

import 'person.dart';

abstract class ChatEngineUserModel {
  PersonModel get person;
  int get lastRead;
}

class ChatEngineUser implements ChatEngineUserModel {
  ChatEngineUser(this.data);

  final JSON data;

  @override
  int get lastRead => data.getProperty<int>(_kLastRead)!;

  @override
  Person get person =>
      Person.fromMap(data.getProperty<KeyValueStore>(_kPerson)!);

  factory ChatEngineUser.parse(String string) =>
      ChatEngineUser(JSON.parse(string));

  static List<ChatEngineUser> parseList(String string) =>
      fromJsonList(JSON.parseList(string));

  static List<ChatEngineUser> fromJsonList(List<JSON> jsonArray) =>
      jsonArray.map((json) => ChatEngineUser(json)).toList();

  static const _kPerson = "person";
  static const _kLastRead = "last_read";
}
