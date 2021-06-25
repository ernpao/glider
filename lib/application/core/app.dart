import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class App extends StatelessWidget {
  final Widget child;
  final List<InheritedProvider>? providers;
  final AppState? appStateModel;

  App({
    required this.child,
    this.appStateModel,
    this.providers,
  });

  @override
  Widget build(BuildContext context) {
    List<InheritedProvider> providersList = [];

    if (appStateModel != null) {
      providersList.add(AppStateProvider(appStateModel));
    }

    providersList..addAll(providers!);

    return MultiProvider(providers: providersList, child: child);
  }
}

/// Helper function for creating a generic Provider.
Provider<T> createProvider<T>(T value) => Provider(create: (_) => value);

/// Helper function for getting the app state with cast.
T getAppStateAs<T>(BuildContext context) =>
    Provider.of<AppState?>(context) as T;
