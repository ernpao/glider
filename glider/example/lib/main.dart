import 'package:flutter/widgets.dart';

import 'demos/demos.dart';

final AuthFlowDemo authFlowDemo = AuthFlowDemo();
final CounterAppDemo counterAppDemo = CounterAppDemo();

const bool kDemoCamera = true;
const bool kDemoSensors = true;
const bool kDemoWidgets = true;
final CustomWidgetsDemo customWidgetsDemo = CustomWidgetsDemo(
  demoCamera: kDemoCamera,
  demoSensors: kDemoSensors,
  demoWebWidgets: kDemoWidgets,
);

final MachineLearningDemo machineLearningDemo = MachineLearningDemo();

void main() {
  runApp(machineLearningDemo);
}
