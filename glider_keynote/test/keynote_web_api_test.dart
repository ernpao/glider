import 'package:flutter_test/flutter_test.dart';
import 'package:glider_keynote/glider_keynote.dart';

void main() {
  final client = KeynoteWebAPI(
    host: "192.168.100.191",
    port: 7982,
    socketPort: 8082,
  );

  test("Keynote Index", () async {
    final response = await client.index();
    assert(response.isSuccessful);
  });

  test("Keynote Websocket Connection", () async {
    client.openSocket();

    final json = JSON();
    json.setProperty("message", "Testing Keynote WebSocket connection.");
    client.sendJson(json);

    await delay(3);
    client.closeSocket();
  });

  test("Keynote Mouse Move Test", () async {
    client.openSocket();
    client.moveMouse(100, 100);
    await delay(.5);
    client.moveMouse(250, 300);
    await delay(.5);
    client.moveMouse(100, 100);
    await delay(.5);
    client.moveMouse(250, 300);
    await delay(.5);
    client.closeSocket();
  });

  test("Keynote Mouse Offset Test", () async {
    client.openSocket();
    client.offsetMouse(200, 200);
    client.closeSocket();
  });

  test("Keynote Mouse Click Test", () async {
    client.openSocket();
    client.clickMouse(MouseButton.right);
    client.closeSocket();
  });

  test("Keynote Keystroke Test", () async {
    client.openSocket();
    client.sendKeystroke("A", modifier: KeyboardModifier.shift);
    client.closeSocket();
  });
}

Future<void> delay(double seconds) async =>
    Future.delayed(Duration(milliseconds: (seconds * 1000).round()));
