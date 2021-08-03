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
          backgroundColor: Colors.grey.shade200,
          drawer: mediaQuery.onPhone ? _Drawer() : null,
          body: Column(
            children: [
              _Header(
                mediaQuery: mediaQuery,
                authState: authState,
              ),
              Expanded(
                child: Row(
                  children: [
                    if (!mediaQuery.onPhone) _Drawer(),
                    Expanded(
                      child: _Body(
                        authState: authState,
                      ),
                    ),
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

class _Body extends StatelessWidget {
  const _Body({required this.authState, Key? key}) : super(key: key);
  final PortalAppAuthFlow authState;
  @override
  Widget build(BuildContext context) {
    return HoverBaseCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Welcome ${authState.activeUser!.username}"),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({
    Key? key,
    required this.authState,
    required this.mediaQuery,
  }) : super(key: key);
  final PortalAppAuthFlow authState;

  final HoverResponsiveHelper mediaQuery;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: Hover.getScreenWidth(context),
      child: HoverBaseCard(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                child: HoverSearchBar(
                  elevation: 4,
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ),
            Expanded(
              flex: widget.mediaQuery.onPhone ? 0 : 6,
              child: const SizedBox.shrink(),
            ),
            HoverCircleIconButton(
              onTap: () {
                _showMenu(context, widget.mediaQuery, widget.authState);
              },
              color: Colors.blue,
              iconColor: Colors.white,
              iconData: Icons.menu,
            ),
          ],
        ),
      ),
    );
  }

  void _showMenu(
    BuildContext context,
    HoverResponsiveHelper mediaQuery,
    PortalAppAuthFlow authState,
  ) {
    const onPhone = false; //mediaQuery.onPhone;
    final screenWidth = mediaQuery.screenWidth;
    final screenHeight = mediaQuery.screenHeight;
    const top = onPhone ? 80.0 : 100.0;
    final right = onPhone ? screenWidth : 40.0;
    final left = onPhone ? 30.0 : screenWidth - right;
    // final menuItemWidth = onPhone ? 200.0 : screenWidth;

    final Map<String, Map> menuItems = {
      "Profile": {
        "icon": Icons.verified_user,
        "onTap": () {},
        "color": Colors.grey.shade400,
      },
      "Settings": {
        "icon": Icons.settings,
        "onTap": () {},
        "color": Colors.grey.shade400,
      },
      "Privacy Policy": {
        "icon": Icons.privacy_tip,
        "onTap": () {},
        "color": Colors.grey.shade400,
      },
      "Logout": {
        "icon": Icons.logout,
        "onTap": authState.logOut,
        "color": Colors.grey.shade400,
      },
    };

    final items = <PopupMenuItem>[];

    menuItems.forEach((label, menuItem) {
      items.add(
        PopupMenuItem(
          height: 60,
          onTap: menuItem["onTap"],
          child: Row(
            children: [
              HoverCircleIconButton(
                iconData: menuItem["icon"],
                color: menuItem["color"],
                iconColor: Colors.white,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(label),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      );
    });

    showMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, screenHeight),
      items: items,
    );
  }
}

class _Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Hover.getScreenHeight(context),
      width: 350,
      child: HoverBaseCard(),
    );
  }
}
