import 'package:flutter/widgets.dart';

import 'demos/demos.dart';

void main() {
  // runApp(AuthFlowDemo());
  // runApp(CounterAppDemo());
  runApp(CustomWidgetsDemo(
    demoCamera: false,
    demoSensors: false,
  ));
}
