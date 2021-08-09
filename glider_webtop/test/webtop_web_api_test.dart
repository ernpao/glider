import 'package:flutter_test/flutter_test.dart';
import 'package:glider_webtop/glider_webtop.dart';

void main() {
  final client = WebtopWebAPI(
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
    json.setProperty("message", "Testing Webtop WebSocket connection.");
    json.setProperty("date", DateTime.now().formattedDate);
    json.setProperty("time", DateTime.now().formattedTime);
    client.sendWsJson(json);

    await Future.delayed(const Duration(seconds: 3));
    client.closeSocket();
  });

  test("Webtop MIDI", () async {
    final api = MidiWebAPI(
      host: "192.168.100.192",
      socketPort: 6868,
    );
    api.openSocket();

    const deviceName = "IAC Driver Webtop MIDI";

    final ccMax = ControlChangeMax(channel: 1, controller: 1);
    final ccMin = ControlChangeMin(channel: 1, controller: 1);

    api.sendMidiCC(deviceName, ccMax);
    await Future.delayed(const Duration(seconds: 2));

    api.sendMidiCC(deviceName, ccMin);
    await Future.delayed(const Duration(seconds: 2));

    api.sendMidiCC(deviceName, ccMax);
    await Future.delayed(const Duration(seconds: 2));

    api.closeSocket();
  });
}
