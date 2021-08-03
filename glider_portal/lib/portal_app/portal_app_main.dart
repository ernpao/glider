import 'package:flutter/material.dart';
import 'package:glider_portal/glider_portal.dart';
import 'package:glider_portal/portal_app/portal_app_auth_flow.dart';
import 'package:hover/hover.dart';

class PortalAppMain extends StatelessWidget {
  const PortalAppMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PortalAppAuthStateConsumer(
      builder: (context, authState) {
        if (authState.currentState != AuthenticationFlowState.LOGGED_IN) {
          return const SizedBox.shrink();
        }
        final mediaQuery = HoverResponsiveHelper(context);
        return Scaffold(
          drawer: mediaQuery.onPhone ? _Drawer() : null,
          body: Row(
            children: [
              if (!mediaQuery.onPhone) _Drawer(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Welcome ${authState.activeUser!.username}"),
                    ),
                    HoverLinkText(
                      "Logout",
                      onTap: authState.logOut,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Hover.getScreenHeight(context),
      width: 300,
      child: HoverBaseCard(
        color: Colors.red,
      ),
    );
  }
}
