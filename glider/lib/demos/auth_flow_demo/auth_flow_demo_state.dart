import 'package:flutter/cupertino.dart';

import '../../glider.dart';

class AuthFlowDemoState extends ChangeNotifier
    with ActiveUser, AuthenticationFlow {
  AuthFlowDemoState({
    this.otpRequired = true,
  });

  AuthFlowDemoUser? _activeUser;

  @override
  AuthFlowDemoUser? get activeUser => _activeUser;

  @override
  final bool otpRequired;

  @override
  Future<bool> logInHandler(String username, String password) async {
    _activeUser = AuthFlowDemoUser(username);
    return true;
  }

  @override
  Future<bool> logOutHandler() async {
    _activeUser = null;
    return true;
  }

  @override
  void onStartSignUp() {
    this.notifyListeners();
  }

  @override
  Future<bool> signUpHandler(String username, String password) async {
    _activeUser = AuthFlowDemoUser(username);
    return true;
  }

  @override
  Future<bool> onOtpSubmitted(String otp) async {
    return true;
  }

  @override
  Future<bool> onOtpCancelled() async {
    return true;
  }

  @override
  void onCancelOtpFail() {
    this.notifyListeners();
  }

  @override
  void onCancelOtpSuccess() {
    this.notifyListeners();
  }

  @override
  void onLoginWithEmailFail() {
    this.notifyListeners();
  }

  @override
  void onLoginWithEmailSuccess() {
    this.notifyListeners();
  }

  @override
  void onLogoutFail() {
    this.notifyListeners();
  }

  @override
  void onLogoutSuccess() {
    this.notifyListeners();
  }

  @override
  void onSignUpWithEmailFail() {
    this.notifyListeners();
  }

  @override
  void onSignUpWithEmailSuccess() {
    this.notifyListeners();
  }

  @override
  void onSubmitOTPFail() {
    this.notifyListeners();
  }

  @override
  void onSubmitOTPSuccess() {
    this.notifyListeners();
  }

  @override
  void onCancelSignUp() {
    this.notifyListeners();
  }

  @override
  void onCancelOtpException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onLoginWithEmailException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onLogoutException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onSignUpWithEmailException(Object error) {
    // Demo only - no errors expected.
  }

  @override
  void onSubmitOTPException(Object error) {
    // Demo only - no errors expected.
  }
}

class AuthFlowDemoUser with Username {
  final String username;
  AuthFlowDemoUser(this.username);
}
