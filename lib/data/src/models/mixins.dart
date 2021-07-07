library mixins;

import 'package:hover/widgets.dart';
import 'package:intl/intl.dart';

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

/// A mixin that gives and object functions for formatting
/// DateTime objects.
mixin DateTimeFormatting {
  /// Formats a DateTime object and displays the time in [h:mm:ss aa] format.
  String formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

  /// Formats a DateTime object and displays the time in [MMM d, yyyy H:m:s aa] format.
  String formatDateTime(DateTime d) =>
      DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

  /// Formats a DateTime object and displays the time in [MMMM d, yyyy] format.
  String formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);
}

mixin EnumToString {
  String enumToString(enumValue) {
    return enumValue.toString().split('.').last;
  }
}
