import 'package:glider/glider.dart';

abstract class ChatEngineUserModel {
  int get id;
  String get username;
  String? get firstName;
  String? get lastName;
  String? get avatar;
  bool get isOnline;
}

class ChatEngineUser implements ChatEngineUserModel {
  ChatEngineUser(this.data);

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

  factory ChatEngineUser.parse(String string) =>
      ChatEngineUser(JSON.parse(string));

  factory ChatEngineUser.fromMap(KeyValueStore map) =>
      ChatEngineUser(JSON.fromMap(map));

  static const String _kAvatar = "avatar";
  static const String _kUsername = "username";
  static const String _kFirstName = "first_name";
  static const String _kLastName = "last_name";
  static const String _kIsOnline = "is_online";
  static const String _kId = "id";
}

class ChatEngineActiveUser extends ChatEngineUser
    with Secret
    implements AuthenticatedUser {
  ChatEngineActiveUser(JSON data, this.secret) : super(data);

  @override
  final String secret;
}
