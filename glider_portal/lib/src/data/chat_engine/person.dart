import 'package:glider/glider.dart';

abstract class PersonModel {
  int get id;
  String get username;
  String? get firstName;
  String? get lastName;
  String? get avatar;
  bool get isOnline;
}

typedef People = List<Person>;

class Person implements PersonModel {
  Person(this.data);

  final JSON data;

  static People fromJsonArray(List<JSON> jsonArray) {
    return jsonArray.map((json) => Person(json)).toList();
  }

  static People peopleFromWebResponse(WebResponse response) {
    if (response.isSuccessful) {
      assert(response.httpResponse.decodedBody is List);
      return fromJsonArray(response.bodyAsJsonList()!);
    }
    throw Exception(
      "Can't get a list of Messages from an unsuccessful web request.",
    );
  }

  @override
  late final String? avatar = data.getProperty<String?>(_kAvatar);

  @override
  late final String? firstName = data.getProperty<String?>(_kFirstName);

  @override
  late final bool isOnline = data.getProperty<bool>(_kIsOnline)!;

  @override
  late final String? lastName = data.getProperty<String?>(_kLastName);

  @override
  late final String username = data.getProperty<String>(_kUsername)!;

  @override
  late final int id = data.getProperty<int>(_kId)!;

  factory Person.parse(String string) => Person(JSON.parse(string));

  factory Person.fromMap(KeyValueStore map) => Person(JSON.fromMap(map));

  static const _kAvatar = "avatar";
  static const _kUsername = "username";
  static const _kFirstName = "first_name";
  static const _kLastName = "last_name";
  static const _kIsOnline = "is_online";
  static const _kId = "id";

  String get initials {
    final first = firstName;
    final last = lastName;
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      final firstInitial = first.split("").first.toUpperCase();
      final lastInitial = last.split("").first.toUpperCase();
      return firstInitial + lastInitial;
    } else {
      if (username.length > 1) {
        return username.substring(0, 2).toUpperCase();
      } else {
        return username.toUpperCase();
      }
    }
  }
}
