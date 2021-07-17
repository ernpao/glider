import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';

class PortalAppAuthState extends ChangeNotifier
    with ActiveUser, AuthenticationFlow {
  PortalAppAuthState({
    required this.api,
  });

  final PortalWebClient api;

  PortalUser? _activeUser;

  @override
  PortalUser? get activeUser => _activeUser;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;
  bool get hasError => _errorMessage != null;

  @override
  Future<bool> logInHandler(String username, String password) async {
    final response = await api.login(username, password);
    _activeUser = response.success
        ? JSON.copyAs<PortalUser>(response.body, PortalUser())
        : null;

    if (response.isNotSuccessful && response.withMessage) {
      _errorMessage = response.message;
    }
    return response.success;
  }

  @override
  Future<bool> logOutHandler() async {
    _activeUser = null;
    return true;
  }

  @override
  void onCancelOtpFail() {
    // No OTP so do nothing.
  }

  @override
  Future<bool> onOtpCancelled() async {
    // No OTP so just return true.
    return true;
  }

  @override
  Future<bool> onOtpSubmitted(String otp) async {
    // No OTP so just return true.
    return true;
  }

  @override
  bool get otpRequired => false;

  @override
  Future<bool> signUpHandler(String username, String password) async {
    final response = await api.register(username, password);
    if (response.success) {
      return true;
    } else {
      if (response.withMessage) {
        _errorMessage = response.message;
      }
      return false;
    }
  }

  @override
  void onCancelOtpSuccess() {
    // No OTP so do nothing.
  }

  @override
  void onCancelSignUp() {
    notifyListeners();
  }

  @override
  void onLoginWithEmailFail() {
    notifyListeners();
  }

  @override
  void onLoginWithEmailSuccess() {
    notifyListeners();
  }

  @override
  void onLogoutFail() {
    notifyListeners();
  }

  @override
  void onLogoutSuccess() {
    notifyListeners();
  }

  @override
  void onSignUpWithEmailFail() {
    notifyListeners();
  }

  @override
  void onSignUpWithEmailSuccess() {
    notifyListeners();
  }

  @override
  void onStartSignUp() {
    // Do nothing.
  }

  @override
  void onSubmitOTPFail() {
    // No OTP so do nothing.
  }

  @override
  void onSubmitOTPSuccess() {
    // No OTP so do nothing.
  }
}
