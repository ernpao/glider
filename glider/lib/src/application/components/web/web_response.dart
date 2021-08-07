import 'package:glider_models/glider_models.dart';
import 'package:http/http.dart';

import 'web_request_headers.dart';

class WebResponse extends Result {
  WebResponse(this.httpResponse)
      : super(
          isSuccessful: httpResponse.isSuccessful,
          message: 'WebResponse Body: ${httpResponse.body}',
        );

  /// The original Response object returned
  /// by the http call.
  final Response httpResponse;

  /// The body of the response as a string.
  String get body => httpResponse.body;

  /// Attempt to parse the body of the response as a [JSON] object.
  ///
  /// Will return null if the body cannot be parse fails.
  JSON? bodyAsJson() {
    try {
      return JSON.parse(httpResponse.body);
    } catch (e) {
      throw Exception(
        "Can't parse the body of WebResponse into a JSON object:"
        "\n${httpResponse.body}",
      );
    }
  }

  List<JSON>? bodyAsJsonList() {
    try {
      return JSON.parseList(httpResponse.body);
    } catch (e) {
      throw Exception(
        "Can't parse the body of WebResponse into a list of JSON objects:"
        "\n${httpResponse.body}",
      );
    }
  }

  /// The HTTP status code for this response.
  int get statusCode => httpResponse.statusCode;

  WebRequestHeaders get headers => httpResponse.headers;
}
