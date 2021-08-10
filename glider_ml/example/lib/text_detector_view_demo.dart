import 'package:flutter/material.dart';
import 'package:glider_ml/glider_ml.dart';
import 'package:hover/hover.dart';

class TextDetectorViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Application(
      theme: HoverThemeData.dark.data,
      child: Builder(builder: (context) {
        return Scaffold(
          body: TextDetectorView(
            overlayBuilder: (context, detectedText) {
              return HoverBaseCard(
                color: Colors.black.withOpacity(0.5),
                child: HoverText(detectedText),
              );
            },
          ),
        );
      }),
    );
  }
}
