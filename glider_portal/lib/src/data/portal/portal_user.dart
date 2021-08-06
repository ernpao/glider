import 'package:flutter/foundation.dart';
import 'package:glider/glider.dart';

/// An implementation of the [UserModel]
/// that is parseable.
class PortalUser extends Parseable
    with EmailAddress
    implements AuthenticatedUser {
  PortalUser._();

  @override
  String get username => super.get<String>("username") ?? "";

  @override
  String get email => super.get<String>("email") ?? "";

  @override
  String get secret => super.get<String>("accessToken") ?? "";

  static final parser = _PortalUserDataParser();
  static PortalUser fromJson(JSON json) {
    PortalUser user = parser.translateFrom<JSON>(json);
    return user;
  }

  static PortalUser parse(String string) {
    PortalUser user = parser.parse(string);
    return user;
  }
}

class _PortalUserDataParser extends Parser<PortalUser> {
  @protected
  @override
  PortalUser createModel() => PortalUser._();

  @override
  Map<String, Type?>? get typeMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
