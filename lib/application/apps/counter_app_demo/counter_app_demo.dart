import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app.dart';
import '../../core/app_state.dart';

/// An app to demonstrate state management using
/// the core library.

class CounterAppDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _DependencyA depA = _DependencyA();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: App(
        child: _CounterApp(),
        appStateModel: _CounterState(),
        providers: [
          // createProvider<_DependencyA>(depA),
          // createProvider<_DependencyB>(_DependencyB()),
        ],
      ),
    );
  }
}

class _CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final counterState = getAppStateAs<_CounterState>(context);
    // final depA = context.read<_DependencyA>();
    // final depB = context.read<_DependencyB>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text('Dependency A:${depA.value}'),
            // Text('Dependency B:${depB.value}'),
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

class _CounterState extends AppState {
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
