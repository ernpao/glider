import 'package:glider/glider.dart';

import 'keynote_interface.dart';
import 'models/models.dart';

class KeynoteWebAPI extends WsAPI implements KeynoteInterface {
  KeynoteWebAPI({
    required String host,
    required int port,
    required int socketPort,
  }) : super(
          host: host,
          useHttps: false,
          useWss: false,
          httpPort: port,
          webSocketPort: socketPort,
        );

  @override
  void sendKeystroke(String key, {KeyboardModifier? modifier}) {
    sendWsData(KeyboardKeystrokeCommand(
      sender: socket.uuid,
      key: key,
      modifier: modifier,
    ));
  }

  @override
  void moveMouse(int x, int y) {
    sendWsData(KeynoteMouseMoveCommand(sender: socket.uuid, x: x, y: y));
  }

  @override
  void clickMouse(MouseButton button) {
    sendWsData(KeynoteMouseClickCommand(
      sender: socket.uuid,
      button: button,
    ));
  }

  @override
  void offsetMouse(int xOffset, int yOffset) {
    sendWsData(KeynoteMouseOffsetCommand(
      sender: socket.uuid,
      xOffset: xOffset,
      yOffset: yOffset,
    ));
  }

  @override
  Future<WebResponse> printMessage(String text) async {
    final request = createGET("/keyboard")
      ..withParameter("keyType", "string")
      ..withParameter("key", text);
    return request.send();
  }
}
