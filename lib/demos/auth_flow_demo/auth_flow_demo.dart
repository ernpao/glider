import 'package:flutter/material.dart';
import 'package:hover/widgets.dart';

import '../../glider.dart';
import 'auth_flow_demo_state.dart';

class AuthFlowDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      appStateModel: AuthFlowDemoState(),
      child: AuthFlowDemoBody(),
    );
  }
}

class AuthFlowDemoBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getAppStateAs<AuthFlowDemoState>(context);

    Widget content;

    if (state.isLoggedOut) {
      content = LoginPage();
    } else if (state.isAwaitingOTP) {
      content = OTPConfirmationPage();
    } else if (state.isSigningUp) {
      content = SignUpPage();
    } else {
      content = HomePage();
    }

    return Scaffold(
      body: Center(child: SingleChildScrollView(child: content)),
    );
  }
}

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getAppStateAs<AuthFlowDemoState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HoverEmailSignUpForm(
          title: "Create A New Account",
          onSubmit: (email, password) {
            if (email != null && password != null) {
              state.signUpWithEmail(email, password);
            }
          },
          formName: "aws-cognito-sign-up",
        ),
        HoverCallToActionButton(
          text: "Log In Instead",
          onPressed: state.cancelSignUp,
          color: Colors.orange,
          maxWidth: 418,
        ),
      ],
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getAppStateAs<AuthFlowDemoState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HoverEmailLoginForm(
          onSubmit: (email, password) {
            state.logInWithEmail(email!, password!);
          },
          formName: "aws-cognito-login",
        ),
        HoverCallToActionButton(
          maxWidth: 418,
          text: "Create New Account",
          color: Colors.orange,
          onPressed: state.startSignUp,
        ),
      ],
    );
  }
}

class OTPConfirmationPage extends StatelessWidget {
  final TextEditingController otpFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = getAppStateAs<AuthFlowDemoState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("OTP Confirmation"),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: TextField(
            controller: otpFieldController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final otp = otpFieldController.text;
            state.submitOTP(otp);
          },
          child: Text("Submit OTP"),
        )
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getAppStateAs<AuthFlowDemoState>(context);
    final currentUser = state.currentUser;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Welcome ${currentUser.username}"),
        ElevatedButton(
          onPressed: () {
            state.logOut();
          },
          child: Text("Logout"),
        )
      ],
    );
  }
}
