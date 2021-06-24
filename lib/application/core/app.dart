import 'package:flutter/widgets.dart';
import 'package:flutter_with_serverless/application/core/dependency.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class App extends StatelessWidget {
  final Widget child;
  final List<Dependency> dependencies;
  final AppState appStateModel;

  App({
    required this.child,
    required this.appStateModel,
    this.dependencies = const [],
  });

  @override
  Widget build(BuildContext context) {
    List<Provider> providers =
        dependencies.map((dep) => DependencyProvider(dep)).toList();
    return AppStateProvider(appStateModel,
        child: MultiProvider(
          providers: providers,
          child: child,
        ));
  }
}
