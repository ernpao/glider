import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class AppState extends ChangeNotifier {
  bool _isUserAuthenticated = false;
  bool get isUserAuthenticated => _isUserAuthenticated;

  /// Function called when the app is set to the authenticated state.
  void onUserAuthorized() {}

  /// Function called when user authentication is revoked.
  void onUserDeauthorized() {}

  /// Sets the application to the authenticated state allowing the user to use
  /// features that require authentication.
  void authorizeUser() {
    _isUserAuthenticated = true;
    onUserAuthorized();
    notifyListeners();
  }

  /// Invalidates the current session and logs out the current user.
  void revokeAuthorization() {
    _isUserAuthenticated = false;
    onUserDeauthorized();
    notifyListeners();
  }
}

class AppStateProvider extends ChangeNotifierProvider<AppState?> {
  AppStateProvider(
    AppState? appStateModel, {
    Widget child = const SizedBox.shrink(),
  }) : super(
          create: (_) => appStateModel,
          child: child,
        );
}
