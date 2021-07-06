library application_layer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state_management/state_management.dart';

export 'hardware/sensors.dart';
export 'state_management/state_management.dart';
export 'ui_widgets/ui_widgets.dart';

/// A MaterialApp wrapped with a MultiProvider widget used for
/// general development of apps with state management
/// and dependency injection.
class Application extends StatelessWidget {
  final Widget child;
  final List<InheritedProvider>? providers;
  final ApplicationState? appStateModel;
  final bool useMaterialAppWidget;
  final bool useSafeArea;
  final ThemeData? theme;

  Application({
    required this.child,
    this.appStateModel,
    this.providers,
    this.useMaterialAppWidget = true,
    this.useSafeArea = true,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    List<InheritedProvider> providersList = [];

    if (appStateModel != null) {
      providersList.add(AppStateProvider(appStateModel!));
    }

    providersList..addAll(providers ?? []);

    Widget content = child;

    if (useMaterialAppWidget) {
      if (useSafeArea) {
        content = SafeArea(child: child);
      }

      content = MaterialApp(
        debugShowCheckedModeBanner: false,
        home: content,
        theme: theme,
      );
    }

    return providersList.isNotEmpty
        ? MultiProvider(
            providers: providersList,
            child: content,
          )
        : content;
  }
}

T getAppStateAs<T>(BuildContext context) {
  return Provider.of<ApplicationState>(context) as T;
}
