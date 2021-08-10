import 'package:glider/glider.dart';

import 'models/models.dart';

abstract class KeynoteInterface {
  void moveMouse(int x, int y);
  void offsetMouse(int xOffset, int yOffset);
  void clickMouse(MouseButton button);
  void sendKeystroke(String keys, {KeyboardModifier? modifier});
  Future<WebResponse> printMessage(String text);
}
