import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';
import 'package:hover/hover.dart';

import 'portal_app_auth_flow.dart';
import 'portal_app_main.dart';

class PortalApp extends StatelessWidget {
  PortalApp({
    Key? key,
  }) : super(key: key);

  /// State management model for authentication
  final authFlowState = PortalAppAuthState(authInterface: AuthWebAPI());

  @override
  Widget build(BuildContext context) {
    return Application(
      providers: [
        ChangeNotifierProvider<PortalAppAuthFlow>.value(value: authFlowState),
      ],
      theme: HoverThemeData.light.data,
      child: PortalAppAuthStateConsumer(
        builder: (context, authState) {
          switch (authState.currentState) {
            case AuthenticationFlowState.LOGGED_IN:
              return PortalAppMain(authState: authState);
            case AuthenticationFlowState.LOGGED_OUT:
              return const _LoginPage();
            case AuthenticationFlowState.SIGNING_UP:
              return const _SignUpPage();
            default:
              return const Text("Invalid State");
          }
        },
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        if (authState.hasError) {
          return HoverText(
            authState.errorMessage!,
            color: Theme.of(context).errorColor,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _LoginPage extends StatelessWidget {
  const _LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        return Scaffold(
          body: !authState.awaitingResponse
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _ErrorMessage(),
                        HoverEmailLoginForm(
                          onSubmit: authState.logInWithEmail,
                          emailController: _loginEmailController,
                          passwordController: _loginPasswordController,
                        ),
                        HoverLinkText(
                          "Create An Account",
                          onTap: authState.startSignUp,
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _SignUpPage extends StatelessWidget {
  const _SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        return Scaffold(
          body: !authState.awaitingResponse
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _ErrorMessage(),
                        HoverEmailSignUpForm(
                          onSubmit: authState.signUpWithEmail,
                          emailController: _signUpEmailController,
                          passwordController: _signUpPasswordController,
                          passwordConfirmationController:
                              _signUpPasswordConfirmationController,
                        ),
                        HoverLinkText(
                          "Log In With Existing Account",
                          onTap: authState.cancelSignUp,
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

/// Text field controllers for login and sign up forms

final _loginEmailController = TextEditingController();
final _loginPasswordController = TextEditingController();
final _signUpEmailController = TextEditingController();
final _signUpPasswordController = TextEditingController();
final _signUpPasswordConfirmationController = TextEditingController();
