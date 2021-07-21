import 'package:intl/intl.dart';

/// A mixin that gives and object functions for formatting
/// DateTime objects.
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

/// Formats a DateTime object and displays the time in [h:mm:ss aa] format.
String _formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

/// Formats a DateTime object and displays the time in [MMM d, yyyy H:m:s aa] format.
String _formatDateTime(DateTime d) =>
    DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

/// Formats a DateTime object and displays the time in [MMMM d, yyyy] format.
String _formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);
