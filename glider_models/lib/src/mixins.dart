library mixins;

import 'dart:developer' as developer;

import 'package:hover/hover.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// A mixin used to give a class the
/// [created] property.
mixin Created {
  /// A timestamp of when this object was created.
  DateTime get created;
}

extension SortByCreated on List<Created> {
  /// Sort items by `created` in ascending order.
  List<Created> sortByCreatedAsc() {
    final data = this;
    data.sort((a, b) => a.created.difference(b.created).inMicroseconds);
    return data;
  }

  /// Sort items by `created` in descending order.
  List<Created> sortByCreatedDesc() {
    return sortByCreatedAsc().reversed.toList();
  }
}

/// A mixin used to give a class the
/// [username] string property.
mixin Username {
  String get username;
}

/// A mixin used to give a class a
/// [secret] string property.
mixin Secret {
  String get secret;
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

  /// This in [h:mm aa] format.
  String get formattedTimeWithoutSeconds => _formatTimeWithoutSeconds(this);

  /// This in [MMM d, yyyy H:m:s aa] format.
  String get formattedDateTime => _formatDateTime(this);

  /// This in [MMM d, yyyy H:m aa] format.
  String get formatDateTimeWithoutSeconds =>
      _formatDateTimeWithoutSeconds(this);

  /// This in [MMMM d, yyyy] format.
  String get formattedDate => _formatDate(this);
}

/// Formats a [DateTime] object and displays the time in 'h:mm:ss aa' format.
String _formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

String _formatTimeWithoutSeconds(DateTime d) => DateFormat("h:mm aa").format(d);

/// Formats a [DateTime] object and displays the time in 'MMM d, yyyy H:m:s aa' format.
String _formatDateTime(DateTime d) =>
    DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

String _formatDateTimeWithoutSeconds(DateTime d) =>
    DateFormat("MMMM d, yyyy h:mm aa").format(d);

/// Formats a DateTime object and displays the time in 'MMMM d, yyyy' format.
String _formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);

extension DebugLogging on Object {
  void log(String? message) {
    if (message != null) {
      developer.log(
        message,
        name: runtimeType.toString(),
        time: DateTime.now(),
      );
    }
  }
}
