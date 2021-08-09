import '../web_mixins.dart';
import '../web_typedefs.dart';
import 'web_request.dart';
import 'web_response.dart';

abstract class WebInterface {
  Future<WebResponse> index();

  /// Send a GET request.
  Future<WebResponse> get(String? requestPath);

  /// Send a POST request.
  Future<WebResponse> post(String? requestPath);

  /// Create a GET request.
  GET createGET(String? requestPath);

  /// Create a POST request.
  POST createPOST(String? requestPath);

  /// Create a DELETE request.
  DELETE createDELETE(String? requestPath);

  /// Create a PUT request.
  PUT createPUT(String? requestPath);

  /// Create a PATCH request.
  PATCH createPATCH(String? requestPath);

  T createRequest<T extends WebRequest>(String? requestPath);
}

class WebClient extends WebInterface with WebURI {
  WebClient({
    required this.host,
    bool useHttps = true,
    this.fixedHeaders,
    this.defaultPort,
  }) {
    withHttps = useHttps;
  }

  @override
  final String host;

  /// A set of headers that will be included
  /// in all requests made by this client.
  final WebRequestHeaders? fixedHeaders;

  /// If set, all requests will be made to this port.
  final int? defaultPort;

  /// Indicates whether requests made by this
  /// client use HTTPS (true by default).
  late final bool withHttps;

  @override
  String get scheme => withHttps ? httpsScheme : httpScheme;

  @override
  Future<WebResponse> index() => createGET("/").send();

  @override
  GET createGET(String? requestPath) => createRequest<GET>(requestPath);

  @override
  POST createPOST(String? requestPath) => createRequest<POST>(requestPath);

  @override
  DELETE createDELETE(String? requestPath) =>
      createRequest<DELETE>(requestPath);

  @override
  PUT createPUT(String? requestPath) => createRequest<PUT>(requestPath);

  @override
  PATCH createPATCH(String? requestPath) => createRequest<PATCH>(requestPath);

  @override
  Future<WebResponse> get(String? requestPath) => createGET(requestPath).send();

  @override
  Future<WebResponse> post(String? requestPath) =>
      createPOST(requestPath).send();

  @override
  T createRequest<T extends WebRequest>(String? requestPath) {
    WebRequest request;
    switch (T) {
      case POST:
        request = POST(host, requestPath, useHttps: withHttps);
        break;
      case DELETE:
        request = DELETE(host, requestPath, useHttps: withHttps);
        break;
      case PUT:
        request = PUT(host, requestPath, useHttps: withHttps);
        break;
      case PATCH:
        request = PATCH(host, requestPath, useHttps: withHttps);
        break;
      default:
        request = GET(host, requestPath, useHttps: withHttps);
        break;
    }
    request
      ..withHeaders(fixedHeaders ?? {})
      ..withPort(defaultPort);

    return request as T;
  }

  @override
  String? get path => null;
}
