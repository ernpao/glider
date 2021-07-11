import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glider/glider.dart';
import 'package:hover/widgets.dart';

void main() {
  runApp(const WebtopGliderDemo());
}

class WebtopGliderDemo extends StatefulWidget {
  const WebtopGliderDemo({Key? key}) : super(key: key);

  @override
  State<WebtopGliderDemo> createState() => _WebtopGliderDemoState();
}

class _WebtopGliderDemoState extends State<WebtopGliderDemo> {
  @override
  Widget build(BuildContext context) {
    return Application(
      theme: ThemeData.dark(),
      child: Column(
        children: [
          CameraControllerWidget(
            builder: (context, data) {
              switch (data.status) {
                case CameraInitializationState.initialized:
                  final controller = data.controller;
                  return CameraPreview(controller!);
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          HoverCallToActionButton(
              text: "Test",
              onPressed: () {
                setState(() {});
              })
        ],
      ),
      useMaterialAppWidget: true,
    );
  }
}
