import 'dart:convert';

import 'mappable.dart';

/// A [Mappable] object that can be encoded into a string
/// using the `jsonEncode` function.
abstract class Encodable extends Mappable {
  /// Converts this [Encodable] into a string via the `dart:convert`
  /// library's `jsonEncode` function.
  ///
  /// This will also convert [DateTime]
  /// objects in the map into ISO8601 strings and [Mappable] objects
  /// into [KeyValueStore] in order for `jsonEncode` to work.
  String encode() => jsonEncode(map(), toEncodable: _toEncodeable);

  /// Converts [nonEncodable] to an encodable object for use
  /// with encoding functions such as `jsonEncode`.
  static Object? _toEncodeable(Object? nonEncodable) {
    if (nonEncodable is Mappable) {
      return nonEncodable.map();
    } else if (nonEncodable is DateTime) {
      return nonEncodable.toIso8601String();
    }
  }

  /// Create a prettified string of this [Encodable] object.
  String prettify() {
    return const JsonEncoder.withIndent('  ', _toEncodeable).convert(map());
  }
}
