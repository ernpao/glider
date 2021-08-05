import 'package:glider_portal/glider_portal.dart';

abstract class ChatInterface {
  /// Users (Private API - requires private key)

  Future<WebResponse> createUser({
    required String username,
    required String firstName,
    required String lastName,
    required String secret,
  });

  Future<WebResponse> getUsers();

  /// User Details (Private API - requires private key)

  Future<WebResponse> getUser(int userId);

  Future<WebResponse> deleteUser(int userId);
}

class ChatAPI implements ChatInterface {
  ChatAPI();

  static final _webClient = WebClient(
    host: "api.chatengine.io",
    useHttps: true,
  );

  static const String _projectId = "ab2204ec-10bc-4807-9f61-ecf012787ced";
  static const String _privateKey = "d243c478-85ad-49d5-80da-f4673bfda05d";

  static const String _usersPath = "/users";

  T _createPrivateRequest<T extends WebRequest>(String path) {
    WebRequest request;
    switch (T) {
      case POST:
        request = _webClient.createPOST(path)..withJsonContentType();
        break;
      case DELETE:
        request = _webClient.createDELETE(path);
        break;
      default:
        request = _webClient.createGET(path);
        break;
    }
    request.withHeader("PRIVATE-KEY", _privateKey);
    return request as T;
  }

  @override
  Future<WebResponse> createUser({
    required String username,
    required String secret,
    required String firstName,
    required String lastName,
  }) {
    final request = _createPrivateRequest<POST>(_usersPath);
    request.withBody(
      JSON()
        ..setProperty("username", username)
        ..setProperty("first_name", firstName)
        ..setProperty("last_name", lastName)
        ..setProperty("secret", secret),
    );
    return request.send();
  }

  @override
  Future<WebResponse> getUser(int userId) {
    final request = _createPrivateRequest<GET>(_usersPath + "/$userId/");
    return request.send();
  }

  @override
  Future<WebResponse> getUsers() {
    final request = _createPrivateRequest<GET>(_usersPath);
    return request.send();
  }

  @override
  Future<WebResponse> deleteUser(int userId) {
    final request = _createPrivateRequest<DELETE>(_usersPath + "/$userId/");
    return request.send();
  }
}
