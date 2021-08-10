import 'package:meta/meta.dart';

enum AuthenticationFlowState {
  LOGGED_IN,
  LOGGED_OUT,
  SIGNING_UP,
  AWAITING_VERIFICATION,
  AWAITING_OTP,
}

mixin AuthenticationFlow {
  AuthenticationFlowState _currentState = AuthenticationFlowState.LOGGED_OUT;

  /// Current state of the authentication flow.
  /// Can either be [LOGGED_IN], [LOGGED_OUT],
  /// [SIGNING_UP], or [AWAITING_OTP].
  AuthenticationFlowState get currentState => _currentState;

  bool get isLoggedIn => currentState == AuthenticationFlowState.LOGGED_IN;
  bool get isLoggedOut => currentState == AuthenticationFlowState.LOGGED_OUT;
  bool get isSigningUp => currentState == AuthenticationFlowState.SIGNING_UP;
  bool get isAwaitingOtp =>
      currentState == AuthenticationFlowState.AWAITING_OTP;
  bool get isAwaitingVerification =>
      currentState == AuthenticationFlowState.AWAITING_VERIFICATION;

  @protected
  void setState(AuthenticationFlowState newState) {
    _currentState = newState;
    onStateUpdated(_currentState);
  }

  void resetFlow() => setState(AuthenticationFlowState.LOGGED_OUT);

  @protected
  void onStateUpdated(AuthenticationFlowState newState);

  bool get otpRequired;

  /// Callback when the sign up flow is triggered.
  @protected
  void onSignUpTriggered();

  /// Callback when the sign up flow is cancelled.
  @protected
  void onSignUpCancelled();

  /// Logout function.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation was successful.
  @protected
  Future<bool> processLogOut();

  /// Function for processing login credentials.
  /// Asynchonously returns a boolean flag that determines
  /// if the login operation was successful.
  @protected
  Future<bool> processCredentials(String username, String password);

  /// Function for handling email/username sign ups.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation was successful.
  @protected
  Future<bool> processSignUp(String username, String password);

  /// The function used to validate a OTP.
  /// Asynchonously returns a boolean flag that determines
  /// if the OTP is valid.
  @protected
  Future<bool> validateOtp(String otp);

  /// The function used to cancel a OTP.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation is successful.
  @protected
  Future<bool> processOtpCancellation();

  /// Success/Fail Callbacks

  @protected
  void onFailureToLogout();
  @protected
  void onSuccessfulLogout();
  @protected
  void onLogoutException(Object error);

  @protected
  void onSuccessfulLogin();
  @protected
  void onFailureToLogin();
  @protected
  void loginExceptionHandler(Object error);

  @protected
  void onSuccessfulSignUp();
  @protected
  void onFailureToSignUp();
  @protected
  void signUpExceptionHandler(Object error);

  @protected
  void onCancelOtpSuccess();
  @protected
  void onCancelOtpFail();
  @protected
  void onCancelOtpException(Object error);

  @protected
  void onSuccessfulOtpValidation();
  @protected
  void onFailureToValidateOtp();
  @protected
  void otpValidationExceptionHandler(Object error);

  String get currentStateAsString {
    switch (currentState) {
      case AuthenticationFlowState.LOGGED_IN:
        return "Logged In";
      case AuthenticationFlowState.SIGNING_UP:
        return "Signing Up";
      case AuthenticationFlowState.AWAITING_OTP:
        return "Awaiting OTP";
      default:
    }

    /// We set default to the [LOGGED_OUT] state, since [currentState] can't be null.
    return "Logged Out";
  }

  void _printBasedOnCurrentState({
    String? whenLoggedIn,
    String? whenLoggedOut,
    String? whenSigningUp,
    String? whileAwaitingOTP,
  }) {
    String? message;
    switch (currentState) {
      case AuthenticationFlowState.LOGGED_IN:
        message = whenLoggedIn;
        break;
      case AuthenticationFlowState.LOGGED_OUT:
        message = whenLoggedOut;
        break;
      case AuthenticationFlowState.SIGNING_UP:
        message = whenSigningUp;
        break;
      case AuthenticationFlowState.AWAITING_OTP:
        message = whileAwaitingOTP;
        break;
      default:
        return;
    }
    print("Current Auth Flow State: $currentStateAsString");
    if (message != null) {
      print(message);
    }
  }

  /// Should only be called if [currentState] is [LOGGED_IN].
  /// Changes the [currentState] to [LOGGED_OUT] if [processLogOut]
  /// returned true. Doesn't change [currentState] otherwise.
  Future<bool> logOut() async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't log out while waiting for OTP.",
      whenLoggedOut: "Already logged out!",
      whenSigningUp: "Can't log out while signing up.",
    );
    if (!isLoggedIn) return false;

    try {
      bool logoutSuccessful = await processLogOut();
      if (logoutSuccessful) {
        onSuccessfulLogout();
        setState(AuthenticationFlowState.LOGGED_OUT);
      } else {
        onFailureToLogout();
      }
      return logoutSuccessful;
    } catch (e) {
      _executeErrorHandler(e, onLogoutException);
    }
    return false;
  }

  /// Log in using email and password credentials.
  /// Should only be called if [currentState] is [LOGGED_OUT].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [processCredentials]
  /// returned true or [AWAITING_OTP] if [otpRequired] is
  /// set to true.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> logIn(String username, String password) async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't log in while waiting for OTP.",
      whenLoggedIn: "Already logged in!",
      whenSigningUp: "Can't log in while signing up.",
    );
    if (!isLoggedOut) return false;

    try {
      bool loginSuccessful = await processCredentials(username, password);
      if (loginSuccessful) {
        onSuccessfulLogin();
        setState(otpRequired
            ? AuthenticationFlowState.AWAITING_OTP
            : AuthenticationFlowState.LOGGED_IN);
      } else {
        onFailureToLogin();
      }
      return loginSuccessful;
    } catch (e) {
      _executeErrorHandler(e, loginExceptionHandler);
    }
    return false;
  }

  /// Sign up using email and password credentials.
  /// Should only be called if [currentState] is [SIGNING_UP].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [processSignUp]
  /// returned true or [AWAITING_OTP] if [otpRequired] is
  /// set to true.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> signUpWithEmail(String email, String password) async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't sign up while waiting for OTP.",
      whenSigningUp: "Already signing up!",
      whenLoggedIn: "Can't sign up while logged in.",
    );

    if (!isSigningUp) return false;

    try {
      bool signUpSuccessful = await processSignUp(email, password);
      if (signUpSuccessful) {
        onSuccessfulSignUp();
        setState(otpRequired
            ? AuthenticationFlowState.AWAITING_OTP
            : AuthenticationFlowState.AWAITING_VERIFICATION);
      } else {
        onFailureToSignUp();
      }
      return signUpSuccessful;
    } catch (e) {
      _executeErrorHandler(e, signUpExceptionHandler);
    }
    return false;
  }

  /// Submits a OTP for validation.
  /// Should only be called if [currentState] is [AWAITING_OTP].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [validateOtp]
  /// returned true. Sets [currentState] to [LOGGED_OUT] if
  /// [processSignUp] returns false.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> submitOtp(String otp) async {
    _printBasedOnCurrentState(
      whenSigningUp: "Can't submit OTP while not waiting for OTP.",
      whenLoggedIn: "Can't submit OTP while not waiting for OTP.",
      whenLoggedOut: "Can't submit OTP while not waiting for OTP.",
    );
    if (!isAwaitingOtp) return false;

    try {
      bool otpIsValid = await validateOtp(otp);
      if (otpIsValid) {
        onSuccessfulOtpValidation();
        setState(AuthenticationFlowState.LOGGED_IN);
      } else {
        onFailureToValidateOtp();
      }
      return otpIsValid;
    } catch (e) {
      _executeErrorHandler(e, otpValidationExceptionHandler);
    }
    return false;
  }

  /// Cancels the [AWAITING_OTP] state and changes the state to [LOGGED_OUT].
  /// Should only be called if [currentState] is [AWAITING_OTP].
  Future<bool> cancelOTP() async {
    _printBasedOnCurrentState(
      whenSigningUp:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
      whenLoggedIn:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
      whenLoggedOut:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
    );
    if (!isAwaitingOtp) return false;

    bool success = false;
    try {
      success = await processOtpCancellation();
      success ? onCancelOtpSuccess() : onCancelOtpFail();

      /// OTP can only be requested when logged out (i.e. during login or sign up)
      /// therefore cancelling the AWAITING_OTP state should set the state back
      /// to LOGGED_OUT.
      setState(AuthenticationFlowState.LOGGED_OUT);
    } catch (e) {
      _executeErrorHandler(e, onCancelOtpException);
      success = false;
    }
    return success;
  }

  /// Calls [onSignUpTriggered] and changes [currentState] to [SIGNING_UP].
  void startSignUp({Function(Object error) onException = print}) {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't sign up while waiting for OTP.",
      whenSigningUp: "Already signing up!",
      whenLoggedIn: "Can't sign up while logged in.",
    );
    if (!isLoggedOut) return;
    try {
      onSignUpTriggered();
      setState(AuthenticationFlowState.SIGNING_UP);
    } catch (e) {
      _executeErrorHandler(e, onException);
    }
  }

  /// Calls [onSignUpCancelled] and changes [currentState] to [LOGGED_OUT].
  /// Should only be called when [currentState] is [SIGNING_UP].
  void cancelSignUp({Function(Object error) onException = print}) {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "No sign up flow to cancel.",
      whenLoggedIn: "No sign up flow to cancel.",
      whenLoggedOut: "No sign up flow to cancel.",
    );
    if (!isSigningUp) return;
    try {
      onSignUpCancelled();
      setState(AuthenticationFlowState.LOGGED_OUT);
    } catch (e) {
      _executeErrorHandler(e, onException);
    }
  }

  /// Execute [errorHandler] and print any exceptions that occur while
  /// handling [error].
  void _executeErrorHandler(Object error, Function(Object) errorHandler) {
    try {
      errorHandler(error);
    } catch (e) {
      print("Exception with errorHandler:");
      print(e);
    }
  }
}
