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
}

class PortalUserDataParser extends Parser<PortalUserData> {
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
