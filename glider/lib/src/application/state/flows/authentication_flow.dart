enum AuthenticationFlowState {
  LOGGED_IN,
  LOGGED_OUT,
  SIGNING_UP,
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
  bool get isAwaitingOTP =>
      currentState == AuthenticationFlowState.AWAITING_OTP;

  bool get otpRequired;

  /// Callback when the sign up flow is triggered.
  void onStartSignUp();

  /// Callback when the sign up flow is cancelled.
  void onCancelSignUp();

  /// Logout function.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation was successful.
  Future<bool> logOutHandler();

  /// Login function that accepts [username] and [password] as inputs.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation was successful.
  Future<bool> logInHandler(String username, String password);

  /// Function for handling email/username sign ups.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation was successful.
  Future<bool> signUpHandler(String username, String password);

  /// The function used to validate a OTP when it is submitted.
  /// Asynchonously returns a boolean flag that determines
  /// if the OTP is valid.
  Future<bool> onOtpSubmitted(String otp);

  /// The function used to cancel the current OTP transaction.
  /// Asynchonously returns a boolean flag that determines
  /// if the operation is successful.
  Future<bool> onOtpCancelled();

  /// Success/Fail Callbacks
  void onLogoutFail();
  void onLogoutSuccess();
  void onLoginWithEmailSuccess();
  void onLoginWithEmailFail();
  void onSignUpWithEmailSuccess();
  void onSignUpWithEmailFail();
  void onCancelOtpSuccess();
  void onCancelOtpFail();
  void onSubmitOTPSuccess();
  void onSubmitOTPFail();

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
    message ?? print(message);
  }

  /// Should only be called if [currentState] is [LOGGED_IN].
  /// Changes the [currentState] to [LOGGED_OUT] if [logOutHandler]
  /// returned true. Doesn't change [currentState] otherwise.
  Future<bool> logOut({
    Function(Object) onError = print,
  }) async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't log out while waiting for OTP.",
      whenLoggedOut: "Already logged out!",
      whenSigningUp: "Can't log out while signing up.",
    );
    if (!isLoggedIn) return false;

    bool success = false;

    try {
      success = await logOutHandler();
      if (success) {
        onLogoutSuccess();
        _currentState = AuthenticationFlowState.LOGGED_OUT;
      } else {
        onLogoutFail();
      }
    } catch (e) {
      _executeErrorHandler(e, onError);
    }
    return success;
  }

  /// Log in using email and password credentials.
  /// Should only be called if [currentState] is [LOGGED_OUT].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [logInHandler]
  /// returned true or [AWAITING_OTP] if [otpRequired] is
  /// set to true.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> logInWithEmail(
    String email,
    String password, {
    Function(Object) onError = print,
  }) async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't log in while waiting for OTP.",
      whenLoggedIn: "Already logged in!",
      whenSigningUp: "Can't log in while signing up.",
    );
    if (!isLoggedOut) return false;

    bool success = false;
    try {
      success = await logInHandler(email, password);
      if (success) {
        onLoginWithEmailSuccess();
        _currentState = otpRequired
            ? AuthenticationFlowState.AWAITING_OTP
            : AuthenticationFlowState.LOGGED_IN;
      } else {
        onLoginWithEmailFail();
      }
    } catch (e) {
      _executeErrorHandler(e, onError);
      success = false;
    }
    return success;
  }

  /// Sign up using email and password credentials.
  /// Should only be called if [currentState] is [SIGNING_UP].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [signUpHandler]
  /// returned true or [AWAITING_OTP] if [otpRequired] is
  /// set to true.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> signUpWithEmail(
    String email,
    String password, {
    Function(Object) onError = print,
  }) async {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't sign up while waiting for OTP.",
      whenSigningUp: "Already signing up!",
      whenLoggedIn: "Can't sign up while logged in.",
    );
    if (!isSigningUp) return false;

    bool success = false;
    try {
      success = await signUpHandler(email, password);
      if (success) {
        onSignUpWithEmailSuccess();
        _currentState = otpRequired
            ? AuthenticationFlowState.AWAITING_OTP
            : AuthenticationFlowState.LOGGED_IN;
      } else {
        onSignUpWithEmailFail();
      }
    } catch (e) {
      _executeErrorHandler(e, onError);
      success = false;
    }
    return success;
  }

  /// Submits a OTP for validation.
  /// Should only be called if [currentState] is [AWAITING_OTP].
  ///
  /// Changes [currentState] to [LOGGED_IN] if [onOtpSubmitted]
  /// returned true. Sets [currentState] to [LOGGED_OUT] if
  /// [signUpHandler] returns false.
  ///
  /// Doesn't change [currentState] if an error
  /// or exception occured.
  Future<bool> submitOTP(
    String otp, {
    Function(Object) onError = print,
  }) async {
    _printBasedOnCurrentState(
      whenSigningUp: "Can't submit OTP while not waiting for OTP.",
      whenLoggedIn: "Can't submit OTP while not waiting for OTP.",
      whenLoggedOut: "Can't submit OTP while not waiting for OTP.",
    );
    if (!isAwaitingOTP) return false;

    bool success = false;
    try {
      success = await onOtpSubmitted(otp);
      if (success) {
        onSubmitOTPSuccess();
        _currentState = AuthenticationFlowState.LOGGED_IN;
      } else {
        onSubmitOTPFail();
      }
    } catch (e) {
      _executeErrorHandler(e, onError);
      success = false;
    }
    return success;
  }

  /// Cancels the [AWAITING_OTP] state and changes the state to [LOGGED_OUT].
  /// Should only be called if [currentState] is [AWAITING_OTP].
  Future<bool> cancelOTP({Function(Object) onError = print}) async {
    _printBasedOnCurrentState(
      whenSigningUp:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
      whenLoggedIn:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
      whenLoggedOut:
          "Can't cancel AWAITING_OTP state while not waiting for OTP.",
    );
    if (!isAwaitingOTP) return false;

    bool success = false;
    try {
      success = await onOtpCancelled();
      success ? onCancelOtpSuccess() : onCancelOtpFail();

      /// OTP can only be requested when logged out (i.e. during login or sign up)
      /// therefore cancelling the AWAITING_OTP state should set the state back
      /// to LOGGED_OUT.
      _currentState = AuthenticationFlowState.LOGGED_OUT;
    } catch (e) {
      _executeErrorHandler(e, onError);
      success = false;
    }
    return success;
  }

  /// Calls [onStartSignUp] and changes [currentState] to [SIGNING_UP].
  void startSignUp({Function(Object) onError = print}) {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "Can't sign up while waiting for OTP.",
      whenSigningUp: "Already signing up!",
      whenLoggedIn: "Can't sign up while logged in.",
    );
    if (!isLoggedOut) return;
    try {
      onStartSignUp();
      _currentState = AuthenticationFlowState.SIGNING_UP;
    } catch (e) {
      _executeErrorHandler(e, onError);
    }
  }

  /// Calls [onCancelSignUp] and changes [currentState] to [LOGGED_OUT].
  /// Should only be called when [currentState] is [SIGNING_UP].
  void cancelSignUp({Function(Object) onError = print}) {
    _printBasedOnCurrentState(
      whileAwaitingOTP: "No sign up flow to cancel.",
      whenLoggedIn: "No sign up flow to cancel.",
      whenLoggedOut: "No sign up flow to cancel.",
    );
    if (!isSigningUp) return;
    try {
      onCancelSignUp();
      _currentState = AuthenticationFlowState.LOGGED_OUT;
    } catch (e) {
      _executeErrorHandler(e, onError);
    }
  }

  /// Execute [errorHandler] and print any exceptions that occur while
  /// handling [error].
  void _executeErrorHandler(Object error, Function(Object) errorHandler) {
    try {
      errorHandler(error);
    } catch (e) {
      print("Error with errorHandler:");
      print(e);
    }
  }
}
