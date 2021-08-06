import 'package:glider/glider.dart';

abstract class AuthInterface {
  /// Generate and resolve a POST request for login.
  Future<WebResponse> logIn(String username, String password);

  /// Register a new user.
  Future<WebResponse> signUp(String username, String password);
}
