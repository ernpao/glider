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
  Future<WebResponse> login(String username, String password) {
    final post = _client.createPOST("/login")
      ..withJsonContentType()
      ..withBody(
        JSON()..set("username", username)..set("password", password),
      );
    return post.resolve();
  }

  @override
  Future<WebResponse> register(
      String email, String username, String password) async {
    final post = _client.createPOST("/register")
      ..withJsonContentType()
      ..withBody(
        JSON()
          ..set("username", username)
          ..set("password", password)
          ..set("email", email),
      );
    return post.resolve();
  }

  @override
  GET verify(String accessToken) =>
      _client.createGET("/verify")..withHeader("x-access-token", accessToken);

  @override
  Future<WebResponse> httpGET(String? path) => _client.httpGET(path);

  @override
  Future<WebResponse> httpPOST(String? path) => _client.httpPOST(path);

  @override
  Future<WebResponse> index() => _client.index();
}
