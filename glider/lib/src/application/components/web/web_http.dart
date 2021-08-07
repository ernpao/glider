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

  /// Create a DELETE request.
  DELETE createDELETE(String? path);

  /// Create a PUT request.
  PUT createPUT(String? path);

  /// Create a PATCH request.
  PATCH createPATCH(String? path);

  T createRequest<T extends WebRequest>(String? path);
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
  GET createGET(String? path) => createRequest<GET>(path);

  @override
  POST createPOST(String? path) => createRequest<POST>(path);

  @override
  DELETE createDELETE(String? path) => createRequest<DELETE>(path);

  @override
  PUT createPUT(String? path) => createRequest<PUT>(path);

  @override
  PATCH createPATCH(String? path) => createRequest<PATCH>(path);

  @override
  Future<WebResponse> get(String? path) => createGET(path).send();

  @override
  Future<WebResponse> post(String? path) => createPOST(path).send();

  @override
  T createRequest<T extends WebRequest>(String? path) {
    WebRequest request;
    switch (T) {
      case POST:
        request = POST(host, path, useHttps: withHttps);
        break;
      case DELETE:
        request = DELETE(host, path, useHttps: withHttps);
        break;
      case PUT:
        request = PUT(host, path, useHttps: withHttps);
        break;
      case PATCH:
        request = PATCH(host, path, useHttps: withHttps);
        break;
      default:
        request = GET(host, path, useHttps: withHttps);
        break;
    }
    request
      ..withHeaders(fixedHeaders ?? {})
      ..withPort(defaultPort);

    return request as T;
  }
}
