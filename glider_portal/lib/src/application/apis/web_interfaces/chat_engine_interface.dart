import 'package:glider/glider.dart';

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
