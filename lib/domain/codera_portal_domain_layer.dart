import '../data/codera_portal_data_layer.dart';
import '../data/src/data_layer.dart';

class CoderaPortalUser extends JSON with EmailAddress {
  String get username => get<String>("username");
  String get email => get<String>("email");
  String get accessToken => get<String>("accessToken");
}

class CoderaPortal implements CoderaPortalAPI {
  final CoderaPortalAPI _api = CoderaPortalClient();

  @override
  Future<CoderaPortalUser?> login(String username, String password) async {
    final res = await (_api.login(username, password));
    return res.success
        ? copyJsonAs<CoderaPortalUser>(res.body, CoderaPortalUser())
        : null;
  }

  @override
  Future<bool> register(String email, String username, String password) async =>
      (await _api.register(email, username, password)).success;

  @override
  Future<bool> verify(String accessToken) async =>
      (await _api.verify(accessToken).resolve()).success;
}
