import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class App extends StatelessWidget {
  final Widget child;
  final List<InheritedProvider>? providers;
  final AppState? appStateModel;
  final bool useMaterialAppWidget;

  App({
    required this.child,
    this.appStateModel,
    this.providers,
    this.useMaterialAppWidget = true,
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
      content = MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
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
  return Provider.of<AppState>(context) as T;
}
