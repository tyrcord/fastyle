// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_calculator_example/ui/pages/sum_calculator.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      routesForMediaType: (mediaType) => [
        GoRoute(path: '/', builder: (_, __) => const SumCalculatorPage()),
      ],
    );
  }
}
