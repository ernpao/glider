import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Base class
abstract class ApplicationState extends ChangeNotifier {
  bool get isAppAuthenticated;
}

class AppStateProvider extends ChangeNotifierProvider<ApplicationState> {
  AppStateProvider(
    ApplicationState appStateModel, {
    Widget child = const SizedBox.shrink(),
  }) : super(
          create: (_) => appStateModel,
          child: child,
        );
}
