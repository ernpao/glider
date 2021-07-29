import 'package:glider_models/glider_models.dart';

abstract class PortalUserModel extends Parseable with Username, EmailAddress {
  String get accessToken;
}

class PortalUser extends PortalUserModel {
  @override
  String get username => get<String>("username") ?? "";

  @override
  String get email => get<String>("email") ?? "";

  @override
  String get accessToken => get<String>("accessToken") ?? "";
}

class PortalUserParser extends Parser<PortalUser> {
  @override
  PortalUser createModel() => PortalUser();

  @override
  Map<String, Type>? get typeMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
