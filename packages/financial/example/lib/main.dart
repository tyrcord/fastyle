import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:matex_financial/financial.dart';
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
  @override
  Widget build(BuildContext context) {
    return const FastApp(
      home: Scaffold(
          body: FastSectionPage(
        child: Column(
          children: [
            MatexSelectInstrumentField(),
          ],
        ),
      )),
    );
  }
}
