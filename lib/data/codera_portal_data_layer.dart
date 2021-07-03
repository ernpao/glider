import 'src/data_layer.dart';

class CoderaPortalClient extends WebClient {
  CoderaPortalClient({
    bool useHttps = true,
  }) : super(
          host: "portal.codera.tech",
          useHttps: useHttps,
        );

  POST login(String username, String password) => post("/login")
    ..withJsonContentType()
    ..withBody(
      JSON()..set("username", username)..set("password", password),
    );

  POST register(String email, String username, String password) =>
      post("/register")
        ..withJsonContentType()
        ..withBody(
          JSON()
            ..set("username", username)
            ..set("password", password)
            ..set("email", email),
        );
}
