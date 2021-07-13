import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../glider.dart';

class CounterAppDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Application(
        child: _CounterApp(),
        providers: [
          Provider(create: (_) => _DependencyA()),
          Provider(create: (_) => _DependencyB()),
          Provider(create: (_) => _CounterState()),
        ],
      ),
    );
  }
}

class _CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterState = context.read<_CounterState>();
    final depA = context.read<_DependencyA>();
    final depB = context.read<_DependencyB>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Dependency A:${depA.value}'),
            Text('Dependency B:${depB.value}'),
            Text('You have pushed the button this many times:'),
            Text(
              '${counterState.count}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counterState.incrementCount,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class _CounterState extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void incrementCount() {
    _count++;
    notifyListeners();
  }
}

class _DependencyA {
  String get value => "This is Dependency A";
}

class _DependencyB {
  String get value => "This is Dependency B";
}
