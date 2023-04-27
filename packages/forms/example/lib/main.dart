import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _value;

  @override
  Widget build(BuildContext context) {
    return FastApp(
      home: FastSectionPage(
        child: Column(children: [
          FastDigitCalculatorField(
            labelText: 'Value A',
            valueText: _value ?? '',
            placeholderText: '0',
            onValueChanged: (value) {
              setState(() => _value = value);
            },
          ),
        ]),
      ),
    );
  }
}
