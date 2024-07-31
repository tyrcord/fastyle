// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_home/fastyle_home.dart';
import 'package:go_router/go_router.dart';
import 'package:t_helpers/helpers.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

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
      routesForMediaType: (mediaType) => [
        GoRoute(
          path: '/',
          builder: (_, __) => FastHomeGraphPage(
            titleText: 'Welcome!',
            subtitleText: 'Have a wonderful day!',
            contentPadding: kFastEdgeInsets16,
            leading: const IconButton(
              onPressed: noop,
              icon: Icon(Icons.settings),
            ),
            actions: const [
              IconButton(
                onPressed: noop,
                icon: Icon(Icons.search),
              ),
            ],
            floatingActionButton: const Icon(Icons.settings),
            appBarExpandedHeight: 250,
            graphType: _graphType,
            children: [
              FastRaisedButton2(
                labelText: 'Line Graph',
                onTap: () {
                  setState(() {
                    _graphType = FastHomeGraphType.line;
                  });
                },
              ),
              FastRaisedButton2(
                labelText: 'Pie Graph',
                onTap: () {
                  setState(() {
                    _graphType = FastHomeGraphType.pie;
                  });
                },
              ),
              FastRaisedButton2(
                labelText: 'Bar Graph',
                onTap: () {
                  setState(() {
                    _graphType = FastHomeGraphType.bar;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
