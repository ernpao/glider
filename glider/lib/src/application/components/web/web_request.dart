import 'package:glider_models/glider_models.dart';
import 'package:http/http.dart' as http;

import 'web_mixins.dart';
import 'web_request_headers.dart';
import 'web_response.dart';

abstract class WebRequest with WebHttpScheme, WebHost {
  WebRequest(
    this.host,
    this.path, {
    this.withHttps = true,
  });
  final String host;
  final bool withHttps;

  final String? path;

  KeyValueStore _queryParameters = {};
  KeyValueStore get queryParameters => _queryParameters;

  /// Adds a query paramter to the request.
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  int? _port;
  int? get port => _port;

  /// Set the target port of the request.
  void withPort(int? port) => _port = port;

  WebRequestHeaders _headers = {};
  WebRequestHeaders get headers => _headers;

  /// Adds headers to this request.
  void withHeaders(WebRequestHeaders headers) => _headers.addAll(headers);

  /// Adds or overrides a request header.
  void withHeader(String key, String value) => _headers[key] = value;

  /// Sets the "Content-Type" header to "application/json".
  void withJsonContentType() => withHeader("Content-Type", "application/json");

  Encodable? _body;
  Encodable? get body => _body;
  void withBody(Encodable body) => _body = body;

  late final Uri uri = Uri(
    host: host,
    path: path,
    port: port,
    queryParameters: queryParameters,
    scheme: webScheme,
  );

  /// Send this web request.
  Future<WebResponse> send();
}

class GET extends WebRequest {
  GET(String host, String? path, {bool useHttps = true})
      : super(host, path, withHttps: useHttps);

  @override
  Future<WebResponse> send() async {
    final response = await http.get(uri, headers: headers);
    return WebResponse(response);
  }
}

class POST extends WebRequest {
  POST(String host, String? path, {bool useHttps = true})
      : super(host, path, withHttps: useHttps);

  @override
  Future<WebResponse> send() async {
    final response = await http.post(
      uri,
      headers: headers,
      body: body?.encode(),
    );
    return WebResponse(response);
  }
}

class DELETE extends WebRequest {
  DELETE(String host, String? path, {bool useHttps = true})
      : super(host, path, withHttps: useHttps);

  @override
  Future<WebResponse> send() async {
    final response = await http.delete(
      uri,
      headers: headers,
      body: body?.encode(),
    );
    return WebResponse(response);
  }
}

class PUT extends WebRequest {
  PUT(String host, String? path, {bool useHttps = true})
      : super(host, path, withHttps: useHttps);

  @override
  Future<WebResponse> send() async {
    final response = await http.put(
      uri,
      headers: headers,
      body: body?.encode(),
    );
    return WebResponse(response);
  }
}

class PATCH extends WebRequest {
  PATCH(String host, String? path, {bool useHttps = true})
      : super(host, path, withHttps: useHttps);

  @override
  Future<WebResponse> send() async {
    final response = await http.patch(
      uri,
      headers: headers,
      body: body?.encode(),
    );
    return WebResponse(response);
  }
}
