library mixins;

import 'package:hover/hover.dart';

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

mixin EnumToString {
  String enumToString(enumValue) {
    return enumValue.toString().split('.').last;
  }
}
