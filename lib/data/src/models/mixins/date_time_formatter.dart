import 'package:intl/intl.dart';

/// A mixin that gives and object functions for formatting
/// DateTime objects.
mixin DateTimeFormatter {
  /// Formats a DateTime object and displays the time in [h:mm:ss aa] format.
  String formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

  /// Formats a DateTime object and displays the time in [MMM d, yyyy H:m:s aa] format.
  String formatDateTime(DateTime d) =>
      DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

  /// Formats a DateTime object and displays the time in [MMMM d, yyyy] format.
  String formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);
}
