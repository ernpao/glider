import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

abstract class AppState extends ChangeNotifier {
  bool get isAppAuthenticated;
}

class AppStateProvider extends ChangeNotifierProvider<AppState> {
  AppStateProvider(
    AppState appStateModel, {
    Widget child = const SizedBox.shrink(),
  }) : super(
          create: (_) => appStateModel,
          child: child,
        );
}
