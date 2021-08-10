import 'package:flutter/material.dart';
import 'package:hover/hover.dart';

import 'package:glider/glider.dart';
import 'auth_flow_demo_state.dart';

class AuthFlowDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      providers: [
        ChangeNotifierProvider<AuthFlowDemoState>(
          create: (_) => AuthFlowDemoState(),
        ),
      ],
      child: _AppBody(),
    );
  }
}

class _AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthFlowDemoState>(context);

    Widget content;

    if (state.isLoggedOut) {
      content = _LoginPage();
    } else if (state.isAwaitingOtp) {
      content = _OTPConfirmationPage();
    } else if (state.isSigningUp) {
      content = _SignUpPage();
    } else {
      content = _HomePage();
    }

    return Scaffold(
      body: Center(child: SingleChildScrollView(child: content)),
    );
  }
}

class _SignUpPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthFlowDemoState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HoverEmailSignUpForm(
          title: "Create A New Account",
          onSubmit: state.signUpWithEmail,
          formName: "aws-cognito-sign-up",
          emailController: emailController,
          passwordController: passwordController,
          passwordConfirmationController: passwordConfirmationController,
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

class _LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthFlowDemoState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HoverEmailLoginForm(
          onSubmit: state.logIn,
          formName: "aws-cognito-login",
          emailController: emailController,
          passwordController: passwordController,
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

class _OTPConfirmationPage extends StatelessWidget {
  final TextEditingController otpFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthFlowDemoState>();
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
            state.submitOtp(otp);
          },
          child: Text("Submit OTP"),
        )
      ],
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthFlowDemoState>();
    final currentUser = state.activeUser!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Welcome ${currentUser.username}"),
        ElevatedButton(
          onPressed: state.logOut,
          child: Text("Logout"),
        )
      ],
    );
  }
}
