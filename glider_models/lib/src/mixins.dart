library mixins;

import 'package:hover/hover.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// A mixin used to give a class the
/// [username] string property.
mixin Username {
  String get username;
}

/// A mixin that gives an object the
/// [mobileNumber] string property.
mixin MobileNumber {
  String get mobileNumber;
  bool get hasValidMobileNumber =>
      HoverFluentValidator().validateAsMobileNumber().check(mobileNumber);
}

/// A mixin that gives an object the
/// [email] string property.
mixin EmailAddress {
  String get email;
  bool get hasValidEmail =>
      HoverFluentValidator().validateAsEmail().check(email);
}

/// A mixin for converting enum values
/// to strings.
mixin EnumToString {
  String enumToString(enumValue) => enumValue.toString().split('.').last;
}

/// A mixin that gives an object a [uuid].
mixin UUID {
  final String uuid = const Uuid().v4();
}

/// A mixin that gives and object functions for formatting
/// [DateTime] objects.
mixin DateTimeFormatter {
  /// Formats a DateTime object and displays the time in [h:mm:ss aa] format.
  String Function(DateTime) get formatTime => _formatTime;

  /// Formats a DateTime object and displays the time in [MMM d, yyyy H:m:s aa] format.
  String Function(DateTime) get formatDateTime => _formatDateTime;

  /// Formats a DateTime object and displays the time in [MMMM d, yyyy] format.
  String Function(DateTime) get formatDate => _formatDate;
}

extension DateTimeFormatting on DateTime {
  /// This in [h:mm:ss aa] format.
  String get formattedTime => _formatTime(this);

  /// This in [MMM d, yyyy H:m:s aa] format.
  String get formattedDateTime => _formatDateTime(this);

  /// This in [MMMM d, yyyy] format.
  String get formattedDate => _formatDate(this);
}

/// Formats a [DateTime] object and displays the time in 'h:mm:ss aa' format.
String _formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

/// Formats a [DateTime] object and displays the time in 'MMM d, yyyy H:m:s aa' format.
String _formatDateTime(DateTime d) =>
    DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

/// Formats a DateTime object and displays the time in 'MMMM d, yyyy' format.
String _formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);
