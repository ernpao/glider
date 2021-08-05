import 'package:flutter/foundation.dart';
import 'package:glider_portal/glider_portal.dart';

abstract class ChatUserModel {
  String get username;
  String? get firstName;
  String? get lastName;
  String? get avatar;
  bool get isOnline;
}

class ChatUser extends Parseable with ChatUserModel {
  static const String _kAvatar = "avatar";
  static const String _kUsername = "username";
  static const String _kFirstName = "first_name";
  static const String _kLastName = "last_name";
  static const String _kIsOnline = "is_online";

  ChatUser._();

  @override
  String? get avatar => super.get<String?>(_kAvatar);

  @override
  String? get firstName => super.get<String?>(_kFirstName);

  @override
  bool get isOnline => super.get<bool>(_kIsOnline)!;

  @override
  String? get lastName => super.get<String?>(_kLastName);

  @override
  String get username => super.get<String>(_kUsername)!;

  static final _parser = _SenderParser();

  factory ChatUser.parse(String string) => _parser.parse(string);

  factory ChatUser.fromJSON(JSON from) => _parser.translateFrom<JSON>(from);

  factory ChatUser.fromMap(KeyValueStore map) => _parser.parseFromMap(map);
}

class _SenderParser extends Parser<ChatUser> {
  @protected
  @override
  ChatUser createModel() => ChatUser._();

  @override
  Map<String, Type?>? get typeMap => {
        ChatUser._kAvatar: String,
        ChatUser._kUsername: String,
        ChatUser._kFirstName: String,
        ChatUser._kLastName: String,
        ChatUser._kIsOnline: bool,
      };
}
