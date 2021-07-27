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

  @override
  Map<String, Type>? get parseMap {
    return {
      "username": String,
      "email": String,
      "accessToken": String,
    };
  }
}
