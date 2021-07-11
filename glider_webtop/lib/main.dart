import 'package:flutter/material.dart';
import 'package:glider/glider.dart';

void main() {
  runApp(const WebtopGliderDemo());
}

class WebtopGliderDemo extends StatelessWidget {
  const WebtopGliderDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Application(
      theme: ThemeData.dark(),
      child: Container(),
      useMaterialAppWidget: true,
    );
  }
}
