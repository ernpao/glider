import 'dart:convert';

import 'mappable.dart';

/// A [Mappable] object that can be encoded into a string.
abstract class Encodable extends Mappable {
  /// Converts this [Encodable] into a string via the `dart:convert`
  /// library's `jsonEncode` function.
  ///
  /// This will also convert [DateTime]
  /// objects in the map into ISO8601 strings and [Mappable] objects
  /// into [Map<String, dynamic>] in order for `jsonEncode` to work.
  String encode() => jsonEncode(map(), toEncodable: toEncodeable);

  /// Converts [nonEncodable] to an encodable object for use
  /// with encoding functions such as `jsonEncode`.
  Object? toEncodeable(Object? nonEncodable) {
    if (nonEncodable is Mappable) {
      return nonEncodable.map();
    } else if (nonEncodable is DateTime) {
      return nonEncodable.toIso8601String();
    }
  }
}
