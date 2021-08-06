import 'package:glider/glider.dart';

import 'web_interfaces/web_interfaces.dart';

class PortalAuthAPI extends WebClient implements AuthInterface {
  PortalAuthAPI() : super(host: "portal.codera.tech", useHttps: true);

  @override
  Future<WebResponse> logIn(String email, String password) {
    final request = createPOST("/login")
      ..withJsonContentType()
      ..withBody(
        JSON()
          ..setProperty("email", email)
          ..setProperty("password", password),
      );

    return request.send();
  }

  /// Register a new user to Portal.
  @override
  Future<WebResponse> signUp(String email, String password) {
    final request = createPOST("/register")
      ..withJsonContentType()
      ..withBody(
        JSON()
          ..setProperty("password", password)
          ..setProperty("email", email),
      );
    return request.send();
  }

  Future<WebResponse> verifyToken(String accessToken) {
    final request = createGET("/verify")
      ..withHeader("x-access-token", accessToken);
    return request.send();
  }
}
