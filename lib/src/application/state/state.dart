library state_management;

export 'flows/flows.dart';
export 'mixins/mixins.dart';

mixin ApplicationState {
  bool get isAppAuthenticated;
}
