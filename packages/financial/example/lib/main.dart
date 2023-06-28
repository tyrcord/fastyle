import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:matex_financial/financial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MatexInstrumentBloc _instrumentBloc;

  @override
  void initState() {
    super.initState();

    // Initialize the calculator bloc.
    _instrumentBloc = MatexInstrumentBloc();

    // Show the splash ad after the first frame is rendered.
    SchedulerBinding.instance.addPostFrameCallback(_loadFinancialInstruments);
  }

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

  _loadFinancialInstruments(_) {
    _instrumentBloc.addEvent(const MatexInstrumentBlocEvent.init());
  }
}
