import 'package:glider/glider.dart';

import 'models/models.dart';

abstract class KeynoteInterface {
  void moveMouse(int x, int y);
  void offsetMouse(int xOffset, int yOffset);
  void clickMouse(MouseButton button);
  void sendKeystroke(String keys, {KeyboardModifier? modifier});
  void broadcast(String message);
  void listenToBroadcasts(Function(String) onMessage);
  Future<WebResponse> sendNote(String note);
  Future<WebResponse> printMessage(String text);
}
