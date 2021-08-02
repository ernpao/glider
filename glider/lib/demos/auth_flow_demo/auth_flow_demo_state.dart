import 'package:flutter/cupertino.dart';

import '../../glider.dart';

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
  void onSignUpTriggered() => this.notifyListeners();

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
  void onCancelOtpFail() => this.notifyListeners();

  @override
  void onCancelOtpSuccess() => this.notifyListeners();

  @override
  void onFailureToLoginWithEmail() => this.notifyListeners();

  @override
  void onSuccessfulLoginWithEmail() => this.notifyListeners();

  @override
  void onFailureToLogout() => this.notifyListeners();

  @override
  void onSuccessfulLogout() => this.notifyListeners();

  @override
  void onFailureToSignUpWithEmail() => this.notifyListeners();

  @override
  void onSuccessfulSignUpWithEmail() => this.notifyListeners();

  @override
  void onFailureToValidateOtp() => this.notifyListeners();

  @override
  void onSuccessfulOtpValidation() => this.notifyListeners();

  @override
  void onSignUpCancelled() => this.notifyListeners();

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
}

class AuthFlowDemoUser with Username {
  final String username;
  AuthFlowDemoUser(this.username);
}
