library state_management;

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

export 'flows/flows.dart';
export 'mixins/mixins.dart';

abstract class ApplicationState extends ChangeNotifier {
  bool get isAppAuthenticated;
}

class AppStateProvider extends ChangeNotifierProvider<ApplicationState> {
  AppStateProvider(
    ApplicationState appStateModel, {
    Widget? child,
  }) : super(
          create: (_) => appStateModel,
          child: child,
        );
}
