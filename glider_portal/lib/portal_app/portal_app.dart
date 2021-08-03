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
  final authFlowState = PortalAppAuthState(authInterface: PortalAuthWebAPI());

  @override
  Widget build(BuildContext context) {
    return Application(
      providers: [
        ChangeNotifierProvider<PortalAppAuthFlow>.value(value: authFlowState),
      ],
      theme: HoverThemeData.dark.data,
      child: PortalAppAuthStateConsumer(
        builder: (context, authState) {
          switch (authState.currentState) {
            case AuthenticationFlowState.LOGGED_IN:
              return const PortalAppMain();
            case AuthenticationFlowState.LOGGED_OUT:
              return PortalAppLoginPage();
            case AuthenticationFlowState.SIGNING_UP:
              return PortalAppSignUpPage();
            default:
              return const Text("Invalid State");
          }
        },
      ),
    );
  }
}

class PortalAppAuthStateErrorMessage extends StatelessWidget {
  const PortalAppAuthStateErrorMessage({Key? key}) : super(key: key);

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

class PortalAppLoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  PortalAppLoginPage({
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
                        const PortalAppAuthStateErrorMessage(),
                        HoverEmailLoginForm(
                          onSubmit: authState.logInWithEmail,
                          emailController: emailController,
                          passwordController: passwordController,
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

class PortalAppSignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  PortalAppSignUpPage({
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
                        const PortalAppAuthStateErrorMessage(),
                        HoverEmailSignUpForm(
                          onSubmit: authState.signUpWithEmail,
                          emailController: emailController,
                          passwordController: passwordController,
                          passwordConfirmationController:
                              passwordConfirmationController,
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
