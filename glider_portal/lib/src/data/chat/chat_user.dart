import 'package:glider_models/glider_models.dart';

abstract class ChatUserModel {
  int get id;
  String get username;
  String? get firstName;
  String? get lastName;
  String? get avatar;
  bool get isOnline;
}

class ChatUser implements ChatUserModel {
  ChatUser(this.data);

  final JSON data;

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

  factory ChatUser.parse(String string) => ChatUser(JSON.parse(string));

  factory ChatUser.fromMap(KeyValueStore map) => ChatUser(JSON.fromMap(map));

  static const String _kAvatar = "avatar";
  static const String _kUsername = "username";
  static const String _kFirstName = "first_name";
  static const String _kLastName = "last_name";
  static const String _kIsOnline = "is_online";
  static const String _kId = "id";
}
