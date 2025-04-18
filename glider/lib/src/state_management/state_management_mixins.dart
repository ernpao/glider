library state_management_mixins;

import 'package:glider_models/glider_models.dart';

import 'models/authenticated_user.dart';

/// A mixin used to give a class the [activeUser] property.
/// Used mainly for designing state management mechanisms
/// that are modelled with user objects.
mixin ActiveUser {
  /// The active user - simply an object
  /// that has a [Username] property.
  AuthenticatedUser? get activeUser;

  /// Indicates if this object currently has an active user.
  bool get withActiveUser => activeUser != null;

  /// Indicates if this object currently does not have an active user.
  bool get withoutActiveUser => !withActiveUser;
}
