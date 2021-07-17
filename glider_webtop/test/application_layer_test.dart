import 'package:flutter_test/flutter_test.dart';
import 'package:glider_webtop/glider_webtop.dart';

void main() {
  final client = WebtopAPI(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  test("Webtop Index", () async {
    final response = await client.index();
    assert(response.success);
  });

  test("Webtop Websocket Connection", () async {
    client.openSocket();

    final json = JSON();
    json.set("message", "Testing Webtop WebSocket connection.");
    json.set("date", DateTime.now().formattedDate);
    json.set("time", DateTime.now().formattedTime);
    client.sendJson(json);

    await Future.delayed(const Duration(seconds: 3));
    client.closeSocket();
  });
}
