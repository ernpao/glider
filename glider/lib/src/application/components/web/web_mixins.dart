import 'package:glider_models/glider_models.dart';

import 'web_typedefs.dart';

/// A mixin used to give an object a [Uri] property.
mixin WebURI {
  /// Scheme used by the URI
  String get scheme;

  String get httpsScheme => "https";
  String get httpScheme => "http";
  String get wsScheme => "ws";
  String get wssScheme => "wss";

  /// Name/IP address of the target host.
  String get host;

  /// Path of the URI.
  String? get path;

  int? _port;
  int? get port => _port;

  WebQueryParameters _queryParameters = {};
  WebQueryParameters get queryParameters => _queryParameters;

  /// Adds a query paramter to the URI of the port.
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  String get query => _queryParameters.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${e.value}')
      .join('&');

  /// Set the target port of the request.
  void withPort(int? port) => _port = port;

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

  /// Adds or overrides a request header.
  void withHeader(String key, String value) => _headers[key] = value;

  /// Sets the "Content-Type" header to "application/json".
  void withJsonContentType() => withHeader("Content-Type", "application/json");
}

mixin WebRequestBody {
  Encodable? _body;
  Encodable? get body => _body;
  void withBody(Encodable body) => _body = body;
}
