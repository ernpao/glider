import 'package:glider_portal/glider_portal.dart';

abstract class ChatEngineInterface {
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

  /// My Details (Authenticate)
  Future<WebResponse> authenticate(String username, String secret);
}

class ChatEngineAPI implements ChatEngineInterface {
  ChatEngineAPI();

  static final _webClient = WebClient(
    host: "api.chatengine.io",
    useHttps: true,
  );

  static const String _projectId = "ab2204ec-10bc-4807-9f61-ecf012787ced";
  static const String _privateKey = "d243c478-85ad-49d5-80da-f4673bfda05d";

  static const String _usersPath = "/users";
  static const String _authenticatePath = "/users/me/";

  T _createRequest<T extends WebRequest>(String? path) {
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
    return request as T;
  }

  T _createPrivateRequest<T extends WebRequest>(String? path) {
    final request = _createRequest<T>(path)
      ..withHeader("PRIVATE-KEY", _privateKey);
    return request;
  }

  T _createUserRequest<T extends WebRequest>(
      String? path, String username, String secret) {
    final request = _createRequest<T>(path);
    request.withHeader("Project-ID", _projectId);
    request.withHeader("User-Name", username);
    request.withHeader("User-Secret", secret);
    return request;
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

  @override
  Future<WebResponse> authenticate(String username, String secret) {
    return _createUserRequest<GET>(_authenticatePath, username, secret).send();
  }
}
