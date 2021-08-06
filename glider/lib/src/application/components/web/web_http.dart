import 'package:glider_models/glider_models.dart';

import 'web_mixins.dart';
import 'web_request.dart';
import 'web_response.dart';
import 'web_request_headers.dart';

abstract class WebInterface {
  Future<WebResponse> index();

  /// Send a GET request.
  Future<WebResponse> get(String? path);

  /// Send a POST request.
  Future<WebResponse> post(String? path);

  /// Create a GET request.
  GET createGET(String? path);

  /// Create a POST request.
  POST createPOST(String? path);

  DELETE createDELETE(String? path);

  PUT createPUT(String? path);

  PATCH createPATCH(String? path);
}

class WebClient extends WebInterface with WebHttpScheme, WebHost, UUID {
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
  final WebRequestHeaders? fixedHeaders;

  /// If set, all requests will be made to this port.
  final int? defaultPort;

  /// Indicates whether requests made by this
  /// client use HTTPS (true by default).
  @override
  late final bool withHttps;

  @override
  Future<WebResponse> index() => createGET("/").send();

  @override
  GET createGET(String? path) => GET(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  POST createPOST(String? path) => POST(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  DELETE createDELETE(String? path) => DELETE(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  PUT createPUT(String? path) => PUT(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  PATCH createPATCH(String? path) => PATCH(host, path, useHttps: withHttps)
    ..withHeaders(fixedHeaders ?? {})
    ..withPort(defaultPort);

  @override
  Future<WebResponse> get(String? path) => createGET(path).send();

  @override
  Future<WebResponse> post(String? path) => createPOST(path).send();
}
