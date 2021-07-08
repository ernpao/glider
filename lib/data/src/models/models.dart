library async;

import 'dart:convert';
import 'package:intl/intl.dart';

import 'abstracts.dart';
import 'mixins.dart';

export 'abstracts.dart';
export 'extensions.dart';
export 'mixins.dart';

class JSON extends Mappable with DebugConsoleLogging {
  Map<String, dynamic> _content = {};
  Map<String, dynamic> get content => _content;

  void set(String key, dynamic value) => _content[key] = value;

  @override
  Map<String, dynamic> map() => _content;

  void _setContent(Map<String, dynamic> content) => _content = content;

  static JSON parse(String jsonString) {
    final Map<String, dynamic> map =
        jsonDecode(jsonString) as Map<String, dynamic>;
    return JSON().._setContent(map);
  }

  static JSON parseMap(Map<String, dynamic> map) => JSON().._setContent(map);

  String get prettified => JsonEncoder.withIndent('  ').convert(_content);

  void debugProperty(String key) => print(get(key));

  @override
  String toString() => prettified;

  /// Copies the contents of a JSON object to another object
  /// that extends the JSON class and returns that object.
  static T copyAs<T extends JSON>(JSON from, T to) {
    to._setContent(from._content);
    return to;
  }
}

/// An object that represents the result of an operation where
/// [success] indicates if the operation was successful.
///
/// The [message] attribute can provided by the operation
/// in the case it needs to pass a message.
abstract class Result with DebugConsoleLogging {
  bool get success;
  bool get isSuccessful => success;
  bool get isNotSuccessful => success;

  String? get message;
  bool get withMessage => message != null;

  @override
  String toString() =>
      "${this.runtimeType} is${success ? " " : " not "}successful. Message: $message";
}

/// A mixin that gives and object functions for formatting
/// DateTime objects.
mixin DateTimeFormatter {
  String Function(DateTime) get formatTime => _formatTime;
  String Function(DateTime) get formatDateTime => _formatDateTime;
  String Function(DateTime) get formatDate => _formatDate;
}

extension DateTimeFormatting on DateTime {
  String get formattedTime => _formatTime(this);
  String get formattedDateTime => _formatDateTime(this);
  String get formattedDate => _formatDate(this);
}

/// Formats a DateTime object and displays the time in [h:mm:ss aa] format.
String _formatTime(DateTime d) => DateFormat("h:mm:ss aa").format(d);

/// Formats a DateTime object and displays the time in [MMM d, yyyy H:m:s aa] format.
String _formatDateTime(DateTime d) =>
    DateFormat("MMMM d, yyyy h:mm:ss aa").format(d);

/// Formats a DateTime object and displays the time in [MMMM d, yyyy] format.
String _formatDate(DateTime d) => DateFormat("MMMM d, yyyy").format(d);
