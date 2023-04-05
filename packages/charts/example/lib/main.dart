import 'package:flutter/material.dart';
import './bar.chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    List<BarItem> data = [
      BarItem(label: 'Item 1', value: 80),
      BarItem(label: 'Item 2', value: -20),
      BarItem(label: 'Item 3', value: 40),
      BarItem(label: 'Item 4', value: -60),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Bar Chart'),
            const SizedBox(height: 24.0),
            FractionallySizedBox(
              widthFactor: 0.35,
              alignment: FractionalOffset.center,
              child: BarChart(items: data),
            ),
          ],
        ),
      ),
    );
  }
}
