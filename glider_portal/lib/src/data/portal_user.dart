import 'package:glider_models/glider_models.dart';

abstract class PortalUserModel with Username, EmailAddress {
  String get accessToken;
}

class PortalUser extends Parseable with Username, EmailAddress {
  @override
  String get username => get<String>("username") ?? "";

  @override
  String get email => get<String>("email") ?? "";

  String get accessToken => get<String>("accessToken") ?? "";
}
