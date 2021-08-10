import 'package:http/http.dart' as http;

import '../web_mixins.dart';
import 'web_response.dart';

abstract class WebRequest with WebURI, WebHeaders, WebRequestBody {
  WebRequest(
    this.host,
    this.path, {
    this.withHttps = true,
  });
  final bool withHttps;

  @override
  final String host;

  @override
  late final String scheme = withHttps ? httpsScheme : httpScheme;

  @override
  final String? path;

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
