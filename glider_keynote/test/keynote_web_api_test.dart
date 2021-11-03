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
    const baseDelay = 3.0;

    /// Expected network latency in milliseconds
    const latency = 0.4;

    final rng = Random();

    for (var i = 0; i < count; i++) {
      const baseRandomDelay = 1.0;

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

  test("Keynote Keystroke Test", () async {
    client.openSocket();
    client.sendKeystroke("A", modifier: KeyboardModifier.shift);
    client.closeSocket();
  });
}

Future<void> delay(double seconds) async =>
    Future.delayed(Duration(milliseconds: (seconds * 1000).round()));
