import 'package:flutter/widgets.dart';
import 'package:glider_ml_demo/pose_detector_view_demo.dart';

import 'text_detector_view_demo.dart';

final textDetectorViewDemo = TextDetectorViewDemo();
final poseDetectorViewDemo = PoseDetectorViewDemo();

void main() {
  // runApp(textDetectorViewDemo);
  runApp(poseDetectorViewDemo);
}
