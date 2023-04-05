import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_digit_calculator/digit_calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const FastApp(
      home: Scaffold(
        body: FastDigitCalculator(),
      ),
    );
  }
}
