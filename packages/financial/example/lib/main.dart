// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FastApp(
      routesForMediaType: (mediaType) => [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            body: FastSectionPage(
              child: Column(
                children: [],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
