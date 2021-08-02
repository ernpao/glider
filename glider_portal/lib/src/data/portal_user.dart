import 'package:glider_models/glider_models.dart';

abstract class PortalUserModel with Username, EmailAddress {
  String get accessToken;
}

/// An implementation of the [PortalUserModel]
/// that is parseable.
class PortalUserData extends Parseable
    with Username, EmailAddress
    implements PortalUserModel {
  @override
  String get username => get<String>("username") ?? "";

  @override
  String get email => get<String>("email") ?? "";

  @override
  String get accessToken => get<String>("accessToken") ?? "";

  static PortalUserData fromJSON(JSON json) {
    final parser = _PortalUserDataParser();
    PortalUserData user = parser.translateFrom<JSON>(json);
    return user;
  }
}

class _PortalUserDataParser extends Parser<PortalUserData> {
  @override
  PortalUserData createModel() => PortalUserData();

  @override
  Map<String, Type>? get typeMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
