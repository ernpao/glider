import 'package:flutter_test/flutter_test.dart';
import 'package:glider_webtop/glider_webtop.dart';
import 'package:glider_webtop/src/application/api/midi/control_change.dart';

void main() {
  final client = WebtopWebClient(
    host: "192.168.100.191",
    port: 6767,
    socketPort: 6868,
  );

  test("Webtop Index", () async {
    final result = await client.index();
    assert(result.isSuccessful);
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

  test("Webtop MIDI", () async {
    client.openSocket();

    const deviceName = "IAC Driver Webtop MIDI";

    client.sendCC(
      deviceName,
      ControlChange(channel: 1, value: 127, controller: 1),
    );

    await Future.delayed(const Duration(seconds: 3));
    client.closeSocket();
  });
}
