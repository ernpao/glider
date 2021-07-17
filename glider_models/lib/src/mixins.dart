library mixins;

import 'package:uuid/uuid.dart';
import 'package:hover/hover.dart';

/// A mixin used to give a class the
/// [username] string property.
mixin Username {
  String get username;
}

/// A mixin that gives an object the
/// [mobileNumber] string property.
mixin MobileNumber {
  String get mobileNumber;
  bool get mobileNumberIsValid =>
      HoverFluentValidator().validateAsMobileNumber().check(mobileNumber);
}

/// A mixin that gives an object the
/// [email] string property.
mixin EmailAddress {
  String get email;
  bool get emailIsValid =>
      HoverFluentValidator().validateAsEmail().check(email);
}

/// A mixin for converting enum values
/// to strings.
mixin EnumToString {
  String enumToString(enumValue) => enumValue.toString().split('.').last;
}

/// A mixin that gives an object the
/// [uuid] string property.
mixin UUID {
  final String uuid = const Uuid().v4();
}
