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

class ChatEngineActiveUser extends ChatEngineUser
    with Secret
    implements AuthenticatedUser {
  ChatEngineActiveUser(JSON data, this.secret) : super(data);

  @override
  final String secret;
}
