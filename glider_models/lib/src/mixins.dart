library mixins;

import 'package:hover/widgets.dart';

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

/// A mixin that allows the object to call
/// the debug() method.
///
/// This converts the
/// calling object into a string (using
/// the toString() method). The resulting
/// string is logged to the to the debug
///  console using print().
mixin DebugConsoleLogging {
  /// Prints self to the debug console.
  void debug() => print(this.toString());
}

mixin EnumToString {
  String enumToString(enumValue) {
    return enumValue.toString().split('.').last;
  }
}
