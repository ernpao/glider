import 'package:glider/glider.dart';

import 'data_layer.dart';

abstract class CoderaPortalAPI {
  login(String username, String password);
  register(String email, String username, String password);
  verify(String accessToken);
}

class CoderaPortalClient implements CoderaPortalAPI, WebHttpClient {
  CoderaPortalClient({
    this.useHttps = true,
  });

  final bool useHttps;

  late final WebClient _client = WebClient(
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

class CoderaPortal implements CoderaPortalAPI {
  final CoderaPortalAPI _api = CoderaPortalClient();

  @override
  Future<CoderaPortalUser?> login(String username, String password) async {
    final res = await (_api.login(username, password));
    return res.success
        ? JSON.copyAs<CoderaPortalUser>(res.body, CoderaPortalUser())
        : null;
  }

  @override
  Future<bool> register(String email, String username, String password) async =>
      (await _api.register(email, username, password)).success;

  @override
  Future<bool> verify(String accessToken) async =>
      (await _api.verify(accessToken).resolve()).success;
}
