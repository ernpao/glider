import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

abstract class UserModel with Username, EmailAddress {
  String get accessToken;
}

/// An implementation of the [UserModel]
/// that is parseable.
class User extends Parseable with Username, EmailAddress implements UserModel {
  @override
  String get username => get<String>("username") ?? "";

  @override
  String get email => get<String>("email") ?? "";

  @override
  String get accessToken => get<String>("accessToken") ?? "";

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
  User createModel() => User();

  @override
  Map<String, Type?>? get typeMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
