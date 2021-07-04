import 'src/data_layer.dart';

class CoderaPortalClient extends WebClient {
  CoderaPortalClient({
    bool useHttps = true,
  }) : super(
          host: "portal.codera.tech",
          useHttps: useHttps,
        );

  POST login(String username, String password) => httpPOST("/login")
    ..withJsonContentType()
    ..withBody(
      JSON()..set("username", username)..set("password", password),
    );

  POST register(String email, String username, String password) =>
      httpPOST("/register")
        ..withJsonContentType()
        ..withBody(
          JSON()
            ..set("username", username)
            ..set("password", password)
            ..set("email", email),
        );

  GET verify(String accessToken) =>
      httpGET("/verify")..withHeader("x-access-token", accessToken);
}
