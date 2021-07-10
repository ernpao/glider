import '../../glider.dart';

class AuthFlowDemoUser {
  final String username;
  AuthFlowDemoUser(this.username);
}

class AuthFlowDemoState extends ApplicationState with AuthFlowMixin {
  AuthFlowDemoState({
    this.otpRequired = true,
  });

  AuthFlowDemoUser? _currentUser;
  AuthFlowDemoUser get currentUser => _currentUser!;

  @override
  final bool otpRequired;

  @override
  bool get isAppAuthenticated => isLoggedIn;

  @override
  Future<bool> Function(String, String) get logInHandler =>
      (username, password) async {
        _currentUser = AuthFlowDemoUser(username);
        return true;
      };

  @override
  Future<bool> Function() get logOutHandler => () async {
        _currentUser = null;
        return true;
      };

  @override
  void Function() get onStartSignUp => this.notifyListeners;

  @override
  Future<bool> Function(String, String) get signUpHandler =>
      (username, password) async {
        _currentUser = AuthFlowDemoUser(username);
        return true;
      };

  @override
  Future<bool> Function(String) get onOtpSubmitted => (otp) async {
        return true;
      };

  @override
  Future<bool> Function() get onOtpCancelled => () async {
        return true;
      };

  @override
  Function get onCancelOtpFail => this.notifyListeners;

  @override
  Function get onCancelOtpSuccess => this.notifyListeners;

  @override
  Function get onLoginWithEmailFail => this.notifyListeners;

  @override
  Function get onLoginWithEmailSuccess => this.notifyListeners;

  @override
  Function get onLogoutFail => this.notifyListeners;

  @override
  Function get onLogoutSuccess => this.notifyListeners;

  @override
  Function get onSignUpWithEmailFail => this.notifyListeners;

  @override
  Function get onSignUpWithEmailSuccess => this.notifyListeners;

  @override
  Function get onSubmitOTPFail => this.notifyListeners;

  @override
  Function get onSubmitOTPSuccess => this.notifyListeners;

  @override
  Function get onCancelSignUp => this.notifyListeners;
}
