// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_animation/fastyle_animation.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FastApp(
      routesForMediaType: (mediaType) => [
        GoRoute(path: '/', builder: (_, __) => const MyHomePage()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const SafeArea(
        child: Center(
          child: FastTyrcordAnimatedLogo(),
        ),
      ),
    );
  }
}
