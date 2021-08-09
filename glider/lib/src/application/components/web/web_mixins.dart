import 'package:flutter/foundation.dart';
import 'package:glider_models/glider_models.dart';

import 'web_typedefs.dart';

/// A mixin used to give an object a [Uri] property.
mixin WebURI {
  /// Scheme component of the URI.
  String get scheme;

  /// Evaluates to "https".
  ///
  /// For use as a non-static
  /// getter that returns a constant value and is
  /// mainly used by classes that use this mixin.
  @protected
  String get httpsScheme => "https";

  /// Evaluates to "http".
  ///
  /// For use as a non-static
  /// getter that returns a constant value and is
  /// mainly used by classes that use this mixin.
  @protected
  String get httpScheme => "http";

  /// Evaluates to "ws".
  ///
  /// For use as a non-static
  /// getter that returns a constant value and is
  /// mainly used by classes that use this mixin.
  @protected
  String get wsScheme => "ws";

  /// Evaluates to "ws".
  ///
  /// For use as a non-static
  /// getter that returns a constant value and is
  /// mainly used by classes that use this mixin.
  @protected
  String get wssScheme => "wss";

  /// The host part of the authority component or the URI.
  String get host;

  /// Path component of the URI.
  String? get path;

  int? _port;

  /// The port part of the authority component or the URI.
  int? get port => _port;

  WebQueryParameters _queryParameters = {};
  WebQueryParameters get queryParameters => _queryParameters;

  /// Adds a query paramter to the URI of the port.
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  /// The query component of the URI.
  String get query => _queryParameters.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${e.value}')
      .join('&');

  /// Set the port component of the URI to `port`.
  void withPort(int? port) => _port = port;

  /// A parsed URI (such as a URL) that will be used
  /// by an object with the [WebURI] mixin for web
  /// related features such as HTTP requests or
  /// WebSocket communications.
  late final Uri uri = Uri(
    scheme: scheme,
    host: host,
    path: path,
    port: port,
    query: query,
  );
}

mixin WebHeaders {
  WebRequestHeaders _headers = {};
  WebRequestHeaders get headers => _headers;

  /// Adds headers to this request.
  void withHeaders(WebRequestHeaders headers) => _headers.addAll(headers);

  /// Adds a request header or overwrites its value if it already exists.
  void withHeader(String key, String value) => _headers[key] = value;

  /// Sets the "Content-Type" header to "application/json".
  void withJsonContentType() => withHeader("Content-Type", "application/json");
}

mixin WebRequestBody {
  Encodable? _body;
  Encodable? get body => _body;
  void withBody(Encodable body) => _body = body;
}
