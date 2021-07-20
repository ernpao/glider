import 'package:flutter/material.dart';
import 'package:hover/hover.dart';

import '../../glider.dart';

class MachineLearningDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      theme: HoverThemeData.dark.data,
      child: Builder(builder: (context) {
        return Scaffold(
          body: TextDetectorView(),
        );
      }),
    );
  }
}
