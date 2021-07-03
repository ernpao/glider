library web;

import 'dart:convert';

import 'package:flutter_with_serverless/data/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'mixins.dart';

abstract class WebAPI with WebHTTP, WebHost {
  final String host;
  final Map<String, String>? defaultHeaders;
  final int? defaultPort;

  WebAPI({
    required this.host,
    bool useHttps = true,
    this.defaultHeaders,
    this.defaultPort,
  }) {
    usesHttps = useHttps;
  }

  late final bool usesHttps;

  GET index() => get("/")..withHeaders(defaultHeaders ?? {});

  /// Generates a GET request.
  GET get(String? path) => GET(
        host,
        path,
        useHttps: usesHttps,
      )
        ..withHeaders(defaultHeaders ?? {})
        ..withPort(defaultPort);

  /// Generates a POST request.
  POST post(String? path) => POST(
        host,
        path,
        useHttps: usesHttps,
      )
        ..withHeaders(defaultHeaders ?? {})
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

extension ResponseExtensions on Response {
  dynamic get decodedBody => jsonDecode(body);
  Map<String, dynamic> get decodedBodyAsJson =>
      decodedBody as Map<String, dynamic>;
  bool get hasStatusCode2XX => statusCode.toString().startsWith("2");
  bool get hasStatusCode3XX => statusCode.toString().startsWith("3");
  bool get hasStatusCode4XX => statusCode.toString().startsWith("4");
  bool get hasStatusCode5XX => statusCode.toString().startsWith("5");
  bool get hasSuccessKey => decodedBodyAsJson.keys.toList().contains("success");
  bool get successKeyValue => decodedBodyAsJson["success"];
  bool get isSuccessful => hasSuccessKey ? successKeyValue : hasStatusCode2XX;
}

class WebResponse extends Result {
  final Response httpResponse;
  WebResponse(this.httpResponse);

  String get body => httpResponse.body;
  dynamic get decodedBody => httpResponse.decodedBody;
  Map<String, dynamic> get decodedBodyAsJson => httpResponse.decodedBodyAsJson;
  int get statusCode => httpResponse.statusCode;
  Map<String, String> get headers => httpResponse.headers;

  @override
  String get message => body;

  @override
  bool get success => httpResponse.isSuccessful;
}
