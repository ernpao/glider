import 'src/data_layer.dart';

class CoderaPortalAPI extends WebAPI {
  CoderaPortalAPI({
    bool useHttps = true,
  }) : super(
          host: "portal.codera.tech",
          useHttps: useHttps,
        );

  POST login(String username, String password) => post("/login")
    ..withJsonContentType()
    ..withBody(
      SimpleJSON()..add("username", username)..add("password", password),
    );
}
