import 'package:fastyle_calculator_example/ui/pages/sum_calculator.page.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FastApp(home: SumCalculatorPage());
  }
}
