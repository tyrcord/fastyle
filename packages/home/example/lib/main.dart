// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_home/fastyle_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  FastHomeGraphType _graphType = FastHomeGraphType.line;

  @override
  Widget build(BuildContext context) {
    return FastApp(
      lightTheme: FastTheme.light.indigo,
      darkTheme: FastTheme.dark.indigo,
      home: FastHomeGraphPage(
        titleText: 'Welcome!',
        subtitleText: 'Have a wonderful day!',
        contentPadding: kFastEdgeInsets16,
        leading: IconButton(
          // ignore: no-empty-block
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
        actions: [
          IconButton(
            // ignore: no-empty-block
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        floatingActionButton: const Icon(Icons.settings),
        appBarExpandedHeight: 250,
        graphType: _graphType,
        children: [
          FastRaisedButton(
            text: 'Line Graph',
            onTap: () {
              setState(() {
                _graphType = FastHomeGraphType.line;
              });
            },
          ),
          FastRaisedButton(
            text: 'Pie Graph',
            onTap: () {
              setState(() {
                _graphType = FastHomeGraphType.pie;
              });
            },
          ),
          FastRaisedButton(
            text: 'Bar Graph',
            onTap: () {
              setState(() {
                _graphType = FastHomeGraphType.bar;
              });
            },
          ),
        ],
      ),
    );
  }
}
