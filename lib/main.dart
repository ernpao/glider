import 'package:flutter/widgets.dart';

import 'application/demos/demos.dart';

void main() {
  // runApp(AuthFlowDemo());
  // runApp(CounterAppDemo());
  runApp(CustomWidgetsDemo(
    demoCamera: false,
    demoSensors: false,
  ));
}
