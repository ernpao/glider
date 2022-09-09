import 'package:glider/glider.dart';

import 'keynote_enums.dart';

abstract class KeynoteCommand extends WsData with EnumToString {
  KeynoteCommand({
    required String sender,
    required KeynoteCommandTopic topic,
  }) : super(sender: sender) {
    setTopic(enumToString(topic));
  }
}

abstract class KeynoteMouseCommand extends KeynoteCommand {
  KeynoteMouseCommand({
    required String sender,
    required KeynoteMouseCommandType type,
  }) : super(sender: sender, topic: KeynoteCommandTopic.mouse) {
    setType(enumToString(type));
  }
}

class KeynoteMouseClickCommand extends KeynoteMouseCommand {
  KeynoteMouseClickCommand({
    required String sender,
    required MouseButton button,
  }) : super(
          sender: sender,
          type: KeynoteMouseCommandType.click,
        ) {
    final data = JSON();
    data.set("button", enumToString(button));
    setBody(data.stringify());
  }
}

class KeynoteMouseMoveCommand extends KeynoteMouseCommand {
  KeynoteMouseMoveCommand({
    required String sender,
    required int x,
    required int y,
  }) : super(
          sender: sender,
          type: KeynoteMouseCommandType.move,
        ) {
    final data = JSON();
    data.set("x", x);
    data.set("y", y);
    setBody(data.stringify());
  }
}

class KeynoteMouseOffsetCommand extends KeynoteMouseCommand {
  KeynoteMouseOffsetCommand({
    required String sender,
    required int xOffset,
    required int yOffset,
  }) : super(
          sender: sender,
          type: KeynoteMouseCommandType.offset,
        ) {
    final data = JSON();
    data.set("x", xOffset);
    data.set("y", yOffset);
    setBody(data.stringify());
  }
}

abstract class KeynoteKeyboardCommand extends KeynoteCommand {
  KeynoteKeyboardCommand({
    required String sender,
  }) : super(sender: sender, topic: KeynoteCommandTopic.keyboard);
}

class KeyboardKeystrokeCommand extends KeynoteKeyboardCommand {
  KeyboardKeystrokeCommand({
    required String sender,
    required String key,
    List<KeyboardModifier>? modifiers,
  }) : super(
          sender: sender,
        ) {
    final data = JSON();
    data.set("key", key);

    if (modifiers != null) {
      final modifierStrings =
          modifiers.map((modifier) => enumToString(modifier));
      data.set("modifiers", modifierStrings.toList());
    }

    setBody(data.stringify());
  }
}

class KeynoteBroadcastCommand extends KeynoteCommand {
  KeynoteBroadcastCommand({
    required String sender,
    required String message,
  }) : super(
          sender: sender,
          topic: KeynoteCommandTopic.broadcast,
        ) {
    final data = JSON();
    data.set("message", message);
    setBody(data.stringify());
  }
}
