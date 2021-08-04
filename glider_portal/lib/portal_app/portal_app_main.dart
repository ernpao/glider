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
              onTap: () =>
                  _showMenu(context, widget.mediaQuery, widget.authState),
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
  ) async {
    final screenWidth = mediaQuery.screenWidth;
    final screenHeight = mediaQuery.screenHeight;
    const top = 100.0;
    const right = 40.0;
    final left = screenWidth - right;

    final items = <_HeaderPopupMenuItem>[];

    menuItems.forEach((label, menuItem) {
      items.add(
        _HeaderPopupMenuItem(
          label: label,
          icon: menuItem[_kIcon],
          iconColor: menuItem[_kColor],
          callback: menuItem[_kCallback],
        ),
      );
    });

    final callback = await showMenu<Function>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, screenHeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      items: items,
    );

    callback?.call();
  }

  late final Map<String, Map> menuItems = {
    "Profile": {
      _kIcon: Icons.verified_user,
      _kCallback: () {},
      _kColor: Colors.grey.shade400,
    },
    "Settings": {
      _kIcon: Icons.settings,
      _kCallback: () {},
      _kColor: Colors.grey.shade400,
    },
    "Privacy Policy": {
      _kIcon: Icons.privacy_tip,
      _kCallback: () {},
      _kColor: Colors.grey.shade400,
    },
    "Logout": {
      _kIcon: Icons.logout,
      _kCallback: widget.authState.logOut,
      _kColor: Colors.grey.shade400,
    },
  };

  static const String _kIcon = "icon";
  static const String _kCallback = "callback";
  static const String _kColor = "color";
}

class _HeaderPopupMenuItem extends PopupMenuItem<Function> {
  _HeaderPopupMenuItem({
    required IconData icon,
    required String label,
    required Function()? callback,
    Color? iconColor,
  }) : super(
          height: 60,
          value: callback,
          child: Row(
            children: [
              HoverCircleIconButton(
                iconData: icon,
                color: iconColor,
                iconColor: Colors.white,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(label),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        );
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
