import 'package:flutter/cupertino.dart';

import 'package:glider/glider.dart';

class AuthFlowDemoState extends ChangeNotifier
    with AuthenticationFlow, ActiveUser {
  AuthFlowDemoState({this.otpRequired = true});

  AuthFlowDemoUser? _activeUser;

  @override
  AuthFlowDemoUser? get activeUser => _activeUser;

  @override
  final bool otpRequired;

  @override
  Future<bool> processCredentials(String username, String password) async {
    _activeUser = AuthFlowDemoUser(username);
    return true;
  }

  @override
  Future<bool> processLogOut() async {
    _activeUser = null;
    return true;
  }

  @override
  void onSignUpTriggered() => notifyListeners();

  @override
  Future<bool> processSignUp(String username, String password) async {
    _activeUser = AuthFlowDemoUser(username);
    return true;
  }

  @override
  Future<bool> validateOtp(String otp) async => true;

  @override
  Future<bool> processOtpCancellation() async => true;

  @override
  void onCancelOtpFail() => notifyListeners();

  @override
  void onCancelOtpSuccess() => notifyListeners();

  @override
  void onFailureToLoginWithEmail() => notifyListeners();

  @override
  void onSuccessfulLoginWithEmail() => notifyListeners();

  @override
  void onFailureToLogout() => notifyListeners();

  @override
  void onSuccessfulLogout() => notifyListeners();

  @override
  void onFailureToSignUpWithEmail() => notifyListeners();

  @override
  void onSuccessfulSignUpWithEmail() => notifyListeners();

  @override
  void onFailureToValidateOtp() => notifyListeners();

  @override
  void onSuccessfulOtpValidation() => notifyListeners();

  @override
  void onSignUpCancelled() => notifyListeners();

  @override
  void onCancelOtpException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void loginWithEmailExceptionHandler(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onLogoutException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void signUpWithEmailExceptionHandler(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void otpValidationExceptionHandler(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onStateUpdated(AuthenticationFlowState newState) => notifyListeners();
}

class AuthFlowDemoUser extends AuthenticatedUser {
  AuthFlowDemoUser(this.username);

  @override
  final String username;
}
