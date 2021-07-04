import '../data/codera_portal_data_layer.dart';
import '../data/src/data_layer.dart';

class CoderaPortalUser extends JSON with EmailAddress {
  String get username => get<String>("username");
  String get email => get<String>("email");
  String get accessToken => get<String>("accessToken");
}

class CoderaPortal {
  CoderaPortalClient api = CoderaPortalClient();

  Future<CoderaPortalUser?> login(String username, String password) async {
    final res = await (api.login(username, password).resolve());
    return res.success
        ? copyJsonAs<CoderaPortalUser>(res.body, CoderaPortalUser())
        : null;
  }
}
