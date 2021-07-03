import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_with_serverless/data/src/data_layer.dart';
import 'package:flutter_with_serverless/data/webtop_data_layer.dart';

void main() {
  final client = WebtopClient();
  test("Webtop Index", () async {
    final response = await client.index().resolve();
    response.debug();
    assert(response.success);
  });

  test("Webtop Websocket Connection", () async {
    client.connectToSocket(
      listener: WebSocketListener(onMessage: (j) {
        j.debug();
      }),
    );

    client.pingSocket();

    final json = JSON();
    json.set("message", "Testing Webtop web socket connection.");

    client.sendJsonToSocket(json);

    await Future.delayed(Duration(seconds: 3));
    client.closeSocketConnection();
  });
}
