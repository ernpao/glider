library web;

import 'package:glider_models/glider_models.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'web_mixins.dart';

abstract class WebHttpClient {
  Future<WebResponse> index();

  /// Send a GET request.
  Future<WebResponse> get(String? path);

  /// Send a POST request.
  Future<WebResponse> post(String? path);

  /// Create a GET request.
  GET createGET(String? path);

  /// Create a POST request.
  POST createPOST(String? path);
}

class WebClient extends WebHttpClient with WebHttpScheme, WebHost, UUID {
  WebClient({
    required this.host,
    bool useHttps = true,
    this.fixedHeaders,
    this.defaultPort,
  }) {
    withHttps = useHttps;
  }

  final String host;

  /// A set of headers that will be included
  /// in all requests made by this client.
  final Map<String, String>? fixedHeaders;

  /// If set, all requests will be made to this port.
  final int? defaultPort;

  /// Indicates whether requests made by this
  /// client use HTTPS (true by default).
  @override
  late final bool withHttps;

  @override
  Future<WebResponse> index() => createGET("/").resolve();

  @override
  GET createGET(String? path) => GET(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  POST createPOST(String? path) => POST(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  Future<WebResponse> get(String? path) => createGET(path).resolve();

  @override
  Future<WebResponse> post(String? path) async => createPOST(path).resolve();
}

abstract class WebRequest with WebHttpScheme, WebHost {
  WebRequest(
    this.host,
    this.path, {
    this.withHttps = true,
  });
  final String host;
  final bool withHttps;

  final String? path;

  Map<String, dynamic> _queryParameters = {};
  Map<String, dynamic> get queryParameters => _queryParameters;

  /// Adds a query paramter to the request.
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  int? _port;
  int? get port => _port;

  /// Set the target port of the request.
  void withPort(int? port) => _port = port;

  Map<String, String> _headers = {};
  Map<String, String> get headers => _headers;

  /// Adds headers to the request.
  void withHeaders(Map<String, String> headers) => _headers.addAll(headers);

  /// Adds or overrides a request header.
  void withHeader(String key, String value) => _headers[key] = value;

  /// Sets the "Content-Type" header to "application/json".
  void withJsonContentType() => withHeader("Content-Type", "application/json");

  /// Launch the web request.
  Future<WebResponse> resolve();
}

class GET extends WebRequest {
  GET(String host, String? path, {bool useHttps = true})
      : super(
          host,
          path,
          withHttps: useHttps,
        );

  @override
  Future<WebResponse> resolve() async {
    Uri uri = Uri(
      host: host,
      path: path,
      port: port,
      queryParameters: queryParameters,
      scheme: webScheme,
    );
    final response = await http.get(uri, headers: headers);
    return WebResponse(response);
  }
}

class POST extends WebRequest {
  POST(String host, String? path, {bool useHttps = true})
      : super(
          host,
          path,
          withHttps: useHttps,
        );

  Mappable? _body;
  Mappable? get body => _body;
  void withBody(Mappable body) => _body = body;

  @override
  Future<WebResponse> resolve() async {
    Uri uri = Uri(
      host: host,
      path: path,
      port: port,
      queryParameters: queryParameters,
      scheme: webScheme,
    );
    final response = await http.post(
      uri,
      headers: headers,
      body: body?.encode(),
    );
    return WebResponse(response);
  }
}

class WebResponse extends Result {
  final Response httpResponse;
  WebResponse(this.httpResponse)
      : super(
          isSuccessful: httpResponse.isSuccessful,
          message: 'WebResponse Body: ${httpResponse.body}',
        );

  /// The body of the response as a string.
  String get body => httpResponse.body;

  /// The body of the response as a [JSON] object.
  JSON get bodyAsJson => JSON.parse(httpResponse.body);

  /// The HTTP status code for this response.
  int get statusCode => httpResponse.statusCode;

  Map<String, String> get headers => httpResponse.headers;
}
