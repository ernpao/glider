import 'package:flutter_test/flutter_test.dart';
import 'package:glider/data/src/data_layer.dart';
import 'package:glider/data/webtop_data_layer.dart';

void main() {
  final client = WebtopClient(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  test("Webtop Index", () async {
    final response = await client.index();
    response.body.debug();
    assert(response.success);
  });

  test("Webtop Websocket Connection", () async {
    client.openSocket();
    client.pingSocket();

    final json = JSON();
    json.set("message", "Testing Webtop WebSocket connection.");
    json.set("date", DateTime.now().formattedDate);
    json.set("time", DateTime.now().formattedTime);
    client.sendJson(json);

    await Future.delayed(Duration(seconds: 3));
    client.closeSocket();
  });
}
