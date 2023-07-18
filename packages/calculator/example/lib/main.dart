// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

// Project imports:
import 'package:fastyle_calculator_example/ui/pages/sum_calculator.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const FastApp(home: SumCalculatorPage());
  }
}
