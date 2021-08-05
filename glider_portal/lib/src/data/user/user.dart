import 'package:flutter/foundation.dart';
import 'package:glider/glider.dart';

abstract class UserModel extends AuthenticatedUser with EmailAddress {
  String get accessToken;
}

/// An implementation of the [UserModel]
/// that is parseable.
class User extends Parseable with Username, EmailAddress implements UserModel {
  User._();

  @override
  String get username => super.get<String>("username") ?? "";

  @override
  String get email => super.get<String>("email") ?? "";

  @override
  String get accessToken => super.get<String>("accessToken") ?? "";

  static final parser = _PortalUserDataParser();
  static User fromJson(JSON json) {
    User user = parser.translateFrom<JSON>(json);
    return user;
  }

  static User parse(String string) {
    User user = parser.parse(string);
    return user;
  }
}

class _PortalUserDataParser extends Parser<User> {
  @protected
  @override
  User createModel() => User._();

  @override
  Map<String, Type?>? get typeMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
