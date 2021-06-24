import 'package:provider/provider.dart';

abstract class Dependency {}

class DependencyProvider extends Provider<Dependency> {
  DependencyProvider(Dependency dependency)
      : super(
          create: (_) => dependency,
        );
}
