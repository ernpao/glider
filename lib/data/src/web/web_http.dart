library web;

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/models.dart';
import 'mixins.dart';

class WebClient with WebHTTP, WebHost {
  final String host;

  /// A set of headers that will be included
  /// in all requests made by this client.
  final Map<String, String>? fixedHeaders;

  /// If set, all requests will be made to
  /// this port.
  final int? defaultPort;

  WebClient({
    required this.host,
    bool useHttps = true,
    this.fixedHeaders,
    this.defaultPort,
  }) {
    usesHttps = useHttps;
  }

  /// Indicates whether requests made by this
  /// client use HTTPS (true by default).
  late final bool usesHttps;

  GET index() => httpGET("/")..withHeaders(fixedHeaders ?? {});

  /// Generates a GET request.
  GET httpGET(String? path) => GET(
        host,
        path,
        useHttps: usesHttps,
      )
        ..withHeaders(fixedHeaders ?? {})
        ..withPort(defaultPort);

  /// Generates a POST request.
  POST httpPOST(String? path) => POST(
        host,
        path,
        useHttps: usesHttps,
      )
        ..withHeaders(fixedHeaders ?? {})
        ..withPort(defaultPort);
}

abstract class WebRequest with WebHTTP, WebHost {
  WebRequest(
    this.host,
    this.path, {
    this.usesHttps = true,
  });
  final String host;
  final bool usesHttps;

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
          usesHttps: useHttps,
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
          usesHttps: useHttps,
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
