import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_serverless/data/webtop_data_layer.dart';

void main() {
  final api = WebtopAPI();
  // test("Webtop Index", () async {
  //   final response = await api.index().resolve();
  //   response.debug();
  //   assert(response.success);
  // });

  test("Webtop Websocket Connection", () async {
    api.connectToWebSocket();
  });
}
