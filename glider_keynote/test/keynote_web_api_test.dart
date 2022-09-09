import 'dart:math';

import 'package:flutter/foundation.dart';
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

  test("Keystroke Loop Test", () async {
    client.openSocket();

    /// Number of times to send the keystroke
    const count = 500;

    /// Base delay between keystrokes in seconds
    const baseDelay = 1.3;

    /// Expected network latency in seconds
    const latency = 0.3;

    final rng = Random();

    for (var i = 0; i < count; i++) {
      const baseRandomDelay = 0.5;

      /// Randomb delay in seconds
      final randomDelay = baseRandomDelay * rng.nextDouble();
      final totalDelay = baseDelay + latency + randomDelay;

      debugPrint(
        "Sending keystroke ${i + 1} of $count followed by a delay of $totalDelay seconds.",
      );

      client.sendKeystroke("f1");
      await delay(totalDelay);
    }

    client.closeSocket();
  });

  test("Fast Keystroke Loop Test", () async {
    client.openSocket();

    /// Number of times to send the keystroke
    const count = 500;

    /// Base delay between keystrokes in seconds
    const baseDelay = 0.1;

    /// Expected network latency in seconds
    const latency = 0.01;

    for (var i = 0; i < count; i++) {
      const totalDelay = baseDelay + latency;

      debugPrint(
        "Sending keystroke ${i + 1} of $count followed by a delay of $totalDelay seconds.",
      );

      client.sendKeystroke("enter");
      await delay(totalDelay);
    }

    client.closeSocket();
  });

  test("Keynote Keystroke Test", () async {
    client.openSocket();
    client.sendKeystroke("a", modifiers: [KeyboardModifier.shift]);
    client.closeSocket();
  });

  test("Keynote Notepad Test", () async {
    await client.sendNote("This is a sample note.");
  });

  test("Keynote Multiple Modifiers Test", () async {
    client.openSocket();
    client.sendKeystroke("f",
        modifiers: [KeyboardModifier.control, KeyboardModifier.shift]);
    client.closeSocket();
  });

  test("Keynote Broadcast Test", () async {
    final receiver = KeynoteWebAPI(
      host: "192.168.100.191",
      port: 7982,
      socketPort: 8082,
    );

    client.openSocket();
    receiver.openSocket();

    const sampleMessage = "This is a sample broadcast.";

    receiver.listenToBroadcasts((messageReceived) {
      assert(messageReceived == sampleMessage);
    });
    client.broadcast(sampleMessage);

    await delay(3.0);
    client.closeSocket();
    receiver.closeSocket();
  });
}

Future<void> delay(double seconds) {
  final ms = (seconds * 1000).round();
  return delayMs(ms);
}

Future<void> delayMs(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}
