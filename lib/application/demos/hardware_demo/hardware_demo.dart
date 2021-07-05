import 'package:flutter/material.dart';

import '../../src/application_layer.dart';

class HardwareDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      useMaterialAppWidget: true,
      theme: ThemeData.dark(),
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: CameraControllerWidget(
                builder: (_, controller, __) => CameraPreview(controller),
                onSetupBuilder: (_) => CircularProgressIndicator(),
                onSetupFailedBuilder: (_) => Text("Setup Failed!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
