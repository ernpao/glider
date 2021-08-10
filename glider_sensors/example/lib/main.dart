import 'package:flutter/widgets.dart';

import 'custom_widgets_demo.dart';

const bool kDemoCamera = true;
const bool kDemoSensors = true;
const bool kDemoWidgets = true;
final CustomWidgetsDemo customWidgetsDemo = CustomWidgetsDemo(
  demoCamera: kDemoCamera,
  demoSensors: kDemoSensors,
  demoWebWidgets: kDemoWidgets,
);

void main() {
  runApp(customWidgetsDemo);
}
