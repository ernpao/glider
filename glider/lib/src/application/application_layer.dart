library application_layer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

export 'hardware/hardware.dart';
export 'state/state.dart';
export 'web/web.dart';

/// A MaterialApp wrapped with a MultiProvider widget used for
/// general development of apps with state management
/// and dependency injection.
class Application extends StatelessWidget {
  final Widget child;
  final List<InheritedProvider>? providers;
  final bool useMaterialAppWidget;
  final bool useSafeArea;
  final ThemeData? theme;

  Application({
    required this.child,
    this.providers,
    this.useMaterialAppWidget = true,
    this.useSafeArea = true,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    Widget app = child;

    if (useSafeArea) app = SafeArea(child: app);

    if (useMaterialAppWidget)
      app = MaterialApp(
          debugShowCheckedModeBanner: false, home: app, theme: theme);

    final pList = <InheritedProvider>[]..addAll(providers ?? []);
    if (pList.isNotEmpty) app = MultiProvider(providers: pList, child: app);

    return app;
  }
}
