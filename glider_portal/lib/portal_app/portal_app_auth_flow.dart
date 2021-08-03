import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';

/// Abstraction of the state management model for user authentication.
abstract class PortalAppAuthFlow extends ChangeNotifier
    with ActiveUser, AuthenticationFlow {
  /// Indicates if the authentication flow
  /// has encountered an error.
  bool get hasError;

  /// An error message of the last error
  /// encountered by the authentication
  /// flow.
  String? get errorMessage;

  /// Indicates if the authentication flow
  /// is currently in a state of
  /// waiting for a response
  /// from the remote host.
  bool get awaitingResponse;

  /// The interface that will be used to
  /// connect to the remote host to access
  /// its authentication functions such as
  /// login and signup.
  PortalAuthInterface get authInterface;
}

class PortalAppAuthState extends PortalAppAuthFlow {
  PortalAppAuthState({
    required this.authInterface,
  });

  @override
  final PortalAuthInterface authInterface;

  PortalUserData? _activeUser;

  @override
  PortalUserData? get activeUser => _activeUser;

  @override
  String? get errorMessage => _errorMessage;

  String? _errorMessage;

  @override
  bool get hasError => _errorMessage != null;

  void _getErrorFromResponse(WebResponse response) {
    assert(response.isNotSuccessful);
    final responseBody = response.bodyAsJson()!;
    _errorMessage = responseBody.getProperty<String>("error");
  }

  void _clearError() => _errorMessage = null;

  bool _awaitingResponse = false;

  @override
  bool get awaitingResponse => _awaitingResponse;

  void _setAwait() {
    _awaitingResponse = true;
    notifyListeners();
  }

  void _clearAwait() {
    _awaitingResponse = false;
    notifyListeners();
  }

  @override
  Future<bool> processCredentials(String username, String password) async {
    _clearError();
    _setAwait();

    final loginResult = await authInterface.logIn(username, password);

    if (loginResult.isNotSuccessful) {
      _getErrorFromResponse(loginResult);
    } else if (loginResult.isSuccessful) {
      _activeUser = PortalUserData.fromJSON(loginResult.bodyAsJson()!);
    }

    return loginResult.isSuccessful;
  }

  @override
  Future<bool> processLogOut() async {
    _activeUser = null;
    return true;
  }

  @override
  void onCancelOtpFail() {
    // No OTP so do nothing.
  }

  @override
  Future<bool> processOtpCancellation() async {
    // No OTP so just return true.
    return true;
  }

  @override
  Future<bool> validateOtp(String otp) async {
    // No OTP so just return true.
    return true;
  }

  @override
  bool get otpRequired => false;

  @override
  Future<bool> processSignUp(String username, String password) async {
    _clearError();
    _setAwait();
    final result = await authInterface.register(username, password);
    if (result.isNotSuccessful) _getErrorFromResponse(result);
    return result.isSuccessful;
  }

  @override
  void onCancelOtpSuccess() {
    // No OTP so do nothing.
  }

  @override
  void onSignUpCancelled() {
    _clearError();
    notifyListeners();
  }

  @override
  void onFailureToLoginWithEmail() {
    _clearAwait();
  }

  @override
  void onSuccessfulLoginWithEmail() {
    _clearAwait();
  }

  @override
  void onFailureToLogout() {
    _clearAwait();
  }

  @override
  void onSuccessfulLogout() {
    _clearAwait();
  }

  @override
  void onFailureToSignUpWithEmail() {
    _clearAwait();
  }

  @override
  void onSuccessfulSignUpWithEmail() {
    _clearAwait();
  }

  @override
  void onSignUpTriggered() {
    _clearError();
    notifyListeners();
  }

  @override
  void onFailureToValidateOtp() {
    // No OTP so do nothing.
  }

  @override
  void onSuccessfulOtpValidation() {
    // No OTP so do nothing.
  }

  @override
  void onCancelOtpException(Object error) {
    // No OTP so do nothing.
  }

  @override
  void loginWithEmailExceptionHandler(Object error) {
    _errorMessage = error.toString();
    _clearAwait();
  }

  @override
  void onLogoutException(Object error) {
    _errorMessage = error.toString();
    _clearAwait();
  }

  @override
  void signUpWithEmailExceptionHandler(Object error) {
    _errorMessage = error.toString();
    _clearAwait();
  }

  @override
  void otpValidationExceptionHandler(Object error) {
    // No OTP so do nothing.
  }
}

class PortalAppAuthStateConsumer extends StatelessWidget {
  const PortalAppAuthStateConsumer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final Widget Function(
    BuildContext context,
    PortalAppAuthFlow authState,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<PortalAppAuthFlow>(context);
    return builder(context, authState);
  }
}
