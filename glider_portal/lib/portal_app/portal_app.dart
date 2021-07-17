import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:glider_portal/glider_portal.dart';
import 'package:hover/hover.dart';

import 'portal_app_auth_state.dart';

class PortalApp extends StatelessWidget {
  const PortalApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Application(
      providers: [
        PortalAppAuthStateProvider(
            model: PortalAppAuthState(api: PortalAuthAPI())),
      ],
      child: PortalAppAuthStateConsumer(
        builder: (context, authState) {
          switch (authState.currentState) {
            case AuthenticationFlowState.LOGGED_IN:
              return const PortalAppContent();
            case AuthenticationFlowState.LOGGED_OUT:
              return const PortalAppLoginPage();
            case AuthenticationFlowState.SIGNING_UP:
              return const PortalAppSignUpPage();
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
  const PortalAppLoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        return Scaffold(
          body: !authState.isLoading
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const PortalAppAuthStateErrorMessage(),
                        HoverEmailLoginForm(
                          onSubmit: (email, password) {
                            if (email != null && password != null) {
                              authState.logInWithEmail(email, password);
                            }
                          },
                        ),
                        HoverLinkText(
                          "Create An Account",
                          onTap: () {
                            authState.startSignUp();
                            // authState.logInWithEmail(
                            //   "ernpao@gmail.com",
                            //   "Zero1928!",
                            // );
                          },
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
  const PortalAppSignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        return Scaffold(
          body: !authState.isLoading
              ? Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const PortalAppAuthStateErrorMessage(),
                        HoverEmailSignUpForm(
                          onSubmit: (email, password) {
                            if (email != null && password != null) {
                              authState.signUpWithEmail(email, password);
                            }
                          },
                        ),
                        HoverLinkText(
                          "Log In With Existing Account",
                          onTap: () {
                            authState.cancelSignUp();
                          },
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

class PortalAppContent extends StatelessWidget {
  const PortalAppContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        return Center(
          child: Text("Welcome ${authState.activeUser!.username}"),
        );
      },
    );
  }
}
