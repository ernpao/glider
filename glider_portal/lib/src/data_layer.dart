import 'package:glider_models/glider_models.dart';

class CoderaPortalUser extends JSON with EmailAddress {
  String get username => get<String>("username");
  @override
  String get email => get<String>("email");
  String get accessToken => get<String>("accessToken");
}
