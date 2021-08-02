import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';

class PortalAppAuthState extends ChangeNotifier
    with ActiveUser, AuthenticationFlow {
  PortalAppAuthState({
    required this.auth,
  });

  final PortalAuthInterface auth;

  PortalUserData? _activeUser;

  @override
  PortalUserData? get activeUser => _activeUser;

  String? get errorMessage => _errorMessage;

  String? _errorMessage;

  bool get hasError => _errorMessage != null;

  void _getErrorFromResponse(WebResponse response) {
    assert(response.isNotSuccessful);
    final responseBody = response.bodyAsJson()!;
    _errorMessage = responseBody.getProperty<String>("error");
  }

  void _clearError() => _errorMessage = null;

  bool _awaitingResponse = false;
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

    final loginResult = await auth.logIn(username, password);

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
    final result = await auth.register(username, password);
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
    PortalAppAuthState authState,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<PortalAppAuthState>(context);
    return builder(context, authState);
  }
}
