import 'src/data_layer.dart';

abstract class CoderaPortalClientInterface {
  login(String username, String password);
  register(String email, String username, String password);
  verify(String accessToken);
}

class CoderaPortalClient
    implements CoderaPortalClientInterface, WebClientInterface {
  CoderaPortalClient({
    this.useHttps = true,
  });

  final bool useHttps;

  late WebClient _client = WebClient(
    host: "portal.codera.tech",
    useHttps: useHttps,
  );

  @override
  POST login(String username, String password) => _client.httpPOST("/login")
    ..withJsonContentType()
    ..withBody(
      JSON()..set("username", username)..set("password", password),
    );

  @override
  POST register(String email, String username, String password) =>
      _client.httpPOST("/register")
        ..withJsonContentType()
        ..withBody(
          JSON()
            ..set("username", username)
            ..set("password", password)
            ..set("email", email),
        );

  @override
  GET verify(String accessToken) =>
      _client.httpGET("/verify")..withHeader("x-access-token", accessToken);

  @override
  GET httpGET(String? path) => _client.httpGET(path);

  @override
  POST httpPOST(String? path) => _client.httpPOST(path);

  @override
  GET index() => _client.index();
}
