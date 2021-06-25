import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class App extends StatelessWidget {
  final Widget child;
  final List providers;
  final appStateModel;

  App({
    required this.child,
    required this.appStateModel,
    this.providers = const [],
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;
    List providersList = [];
    providersList
      ..add(AppStateProvider(appStateModel))
      ..addAll(providers);

    return AppStateProvider(
      appStateModel,
      child: Builder(builder: (_) => body),
    );
  }

  static T getAppStateAs<T>(BuildContext context) {
    return Provider.of<AppState>(context) as T;
  }
}
