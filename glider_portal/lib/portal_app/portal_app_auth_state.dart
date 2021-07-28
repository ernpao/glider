import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';

class PortalAppAuthState extends ChangeNotifier
    with ActiveUser, AuthenticationFlow {
  PortalAppAuthState({
    required this.auth,
  });

  final PortalAuthInterface auth;

  PortalUser? _activeUser;

  @override
  PortalUser? get activeUser => _activeUser;

  String? get errorMessage => _errorMessage;
  String? _errorMessage;
  bool get hasError => _errorMessage != null;
  void _clearErrorMessage() {
    _errorMessage = null;
  }

  void _setErrorMessage(String message) {
    _errorMessage = message;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Sets the [isLoading] flag to true
  /// and notifies listeners.
  void _triggerLoadingState() {
    _isLoading = true;
    notifyListeners();
  }

  /// Sets the [isLoading] flag to false
  /// and notifies listeners.
  void _clearLoadingState() {
    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<bool> logInHandler(String username, String password) async {
    _clearErrorMessage();
    _triggerLoadingState();
    final result = await auth.logIn(username, password);
    _activeUser = result.isSuccessful
        ? PortalUserParser().parseFrom<JSON>(result.bodyAsJson)
        : null;

    if (result.isNotSuccessful && result.withMessage) {
      final responseJson = result.bodyAsJson;
      final error = responseJson.get<String>("error");
      if (error != null) {
        _setErrorMessage(error);
      }
    }
    return result.isSuccessful;
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
    _clearErrorMessage();
    _triggerLoadingState();
    final result = await auth.register(username, password);
    if (result.isSuccessful) {
      return true;
    } else {
      final responseJson = result.bodyAsJson;
      _errorMessage = responseJson.get<String>("error");
      return false;
    }
  }

  @override
  void onCancelOtpSuccess() {
    // No OTP so do nothing.
  }

  @override
  void onCancelSignUp() {
    _clearErrorMessage();
    notifyListeners();
  }

  @override
  void onLoginWithEmailFail() {
    _clearLoadingState();
  }

  @override
  void onLoginWithEmailSuccess() {
    _clearLoadingState();
  }

  @override
  void onLogoutFail() {
    _clearLoadingState();
  }

  @override
  void onLogoutSuccess() {
    _clearLoadingState();
  }

  @override
  void onSignUpWithEmailFail() {
    _clearLoadingState();
  }

  @override
  void onSignUpWithEmailSuccess() {
    _clearLoadingState();
  }

  @override
  void onStartSignUp() {
    _clearErrorMessage();
    notifyListeners();
  }

  @override
  void onSubmitOTPFail() {
    // No OTP so do nothing.
  }

  @override
  void onSubmitOTPSuccess() {
    // No OTP so do nothing.
  }

  @override
  void onCancelOtpException(Object error) {
    // No OTP so do nothing.
  }

  @override
  void onLoginWithEmailException(Object error) {
    _setErrorMessage(error.toString());
    _clearLoadingState();
  }

  @override
  void onLogoutException(Object error) {
    _setErrorMessage(error.toString());
    _clearLoadingState();
  }

  @override
  void onSignUpWithEmailException(Object error) {
    _setErrorMessage(error.toString());
    _clearLoadingState();
  }

  @override
  void onSubmitOTPException(Object error) {
    // No OTP so do nothing.
  }
}

class PortalAppAuthStateProvider
    extends ChangeNotifierProvider<PortalAppAuthState> {
  PortalAppAuthStateProvider({
    Key? key,
    required PortalAppAuthState model,
    Widget? child,
  }) : super(
          key: key,
          create: (_) => model,
          child: child,
        );
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
