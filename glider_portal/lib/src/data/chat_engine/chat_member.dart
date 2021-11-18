import 'package:glider_portal/glider_portal.dart';

typedef ChatMembersModel = List<ChatMemberModel>;

abstract class ChatMemberModel {
  PersonModel get person;

  /// ID of the last message read
  /// by the `person` in the chat
  int get lastRead;
}

typedef ChatMembers = List<ChatMember>;

class ChatMember implements ChatMemberModel {
  ChatMember(this.data);

  final JSON data;

  @override
  int get lastRead => data.getProperty<int>(_kLastRead)!;

  @override
  Person get person =>
      Person.fromMap(data.getProperty<KeyValueStore>(_kPerson)!);

  factory ChatMember.parse(String string) => ChatMember(JSON.parse(string));

  static ChatMembers parseList(String string) =>
      fromJsonList(JSON.parseList(string));

  static ChatMembers fromJsonList(List<JSON> jsonArray) =>
      jsonArray.map((json) => ChatMember(json)).toList();

  static ChatMembers activitiesFromWebResponse(WebResponse response) {
    if (response.isSuccessful) {
      assert(response.httpResponse.decodedBody is List);
      return fromJsonList(response.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of ChatMember from an unsuccessful web request.",
    );
  }

  static const _kPerson = "person";
  static const _kLastRead = "last_read";
}
