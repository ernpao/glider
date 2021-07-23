import 'package:glider/glider.dart';

abstract class AuthInterface {
  /// Generate and resolve a POST request for login.
  Future<WebResponse> logIn(String username, String password);

  /// Register a new user to Portal. The [username]
  /// parameter is optional. If it is not provided,
  /// a new user will be created with their [username]
  /// set as the [email] they have provided.
  Future<WebResponse> register(
    String email,
    String password, {
    String? username,
  });

  /// Verify the validity of a user's access token.
  Future<WebResponse> verify(String accessToken);
}

class AuthWebClient extends WebClient implements AuthInterface {
  AuthWebClient() : super(host: "portal.codera.tech", useHttps: true);

  @override
  Future<WebResponse> logIn(String username, String password) {
    final request = createPOST("/login")
      ..withJsonContentType()
      ..withBody(
        JSON()..set("username", username)..set("password", password),
      );

    return request.send();
  }

  @override
  Future<WebResponse> register(String email, String password,
      {String? username}) {
    final request = createPOST("/register")
      ..withJsonContentType()
      ..withBody(
        JSON()
          ..set("username", username ?? email)
          ..set("password", password)
          ..set("email", email),
      );
    return request.send();
  }

  @override
  Future<WebResponse> verify(String accessToken) {
    final request = createGET("/verify")
      ..withHeader("x-access-token", accessToken);
    return request.send();
  }
}
