import 'package:glider_models/glider_models.dart';

/// A model used in state management mechanisms
/// that represents a user that is authenticated
/// to use the application.
abstract class AuthenticatedUser with Username, Secret {}
