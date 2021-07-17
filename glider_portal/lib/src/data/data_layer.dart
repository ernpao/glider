import 'package:glider_models/glider_models.dart';

class PortalUser extends JSON with Username, EmailAddress {
  @override
  String get username => get<String>("username");
  @override
  String get email => get<String>("email");
  String get accessToken => get<String>("accessToken");
}
