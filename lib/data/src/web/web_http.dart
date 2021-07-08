library web;

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/models.dart';
import 'web_mixins.dart';

abstract class WebHttpClient {
  Future<WebResponse> index();

  /// Creates a GET request.
  Future<WebResponse> httpGET(String? path);

  /// Creates a POST request.
  Future<WebResponse> httpPOST(String? path);
}

class WebClient with WebHttpScheme, WebHost implements WebHttpClient {
  final String host;

  /// A set of headers that will be included
  /// in all requests made by this client.
  final Map<String, String>? fixedHeaders;

  /// If set, all requests will be made to this port.
  final int? defaultPort;

  WebClient({
    required this.host,
    bool useHttps = true,
    this.fixedHeaders,
    this.defaultPort,
  }) {
    withHttps = useHttps;
  }

  /// Indicates whether requests made by this
  /// client use HTTPS (true by default).
  @override
  late final bool withHttps;

  @override
  Future<WebResponse> index() => createGET("/").resolve();

  GET createGET(String? path) => GET(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  POST createPOST(String? path) => POST(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  Future<WebResponse> httpGET(String? path) => createGET(path).resolve();

  @override
  Future<WebResponse> httpPOST(String? path) async =>
      createPOST(path).resolve();
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
  void withParameter(String key, dynamic value) =>
      _queryParameters[key] = value;

  int? _port;
  int? get port => _port;
  void withPort(int? port) => _port = port;

  Map<String, String> _headers = {};
  Map<String, String> get headers => _headers;

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
  WebResponse(this.httpResponse);

  JSON get body => JSON.fromMap(httpResponse.decodedBodyAsMap);

  int get statusCode => httpResponse.statusCode;
  Map<String, String> get headers => httpResponse.headers;

  @override
  String get message => httpResponse.body;

  @override
  bool get success => httpResponse.isSuccessful;
}
