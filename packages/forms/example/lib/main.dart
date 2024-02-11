// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_forms/fastyle_forms.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_countries/generated/codegen_loader.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FastAmountSwitchFieldType _fieldType = FastAmountSwitchFieldType.amount;
  String? _percentValue;
  String? _amountValue;
  String? _value;

  @override
  Widget build(BuildContext context) {
    return FastApp(
      assetLoader: LinguaLoader.withLocales(mapLocales: [
        CountriesCodegenLoader.mapLocales,
      ]),
      routesForMediaType: (mediaType) => [
        GoRoute(
          path: '/',
          builder: (_, __) => FastSectionPage(
            child: Column(children: [
              FastDigitCalculatorField(
                labelText: 'Value A',
                valueText: _value ?? '',
                placeholderText: '0',
                onValueChanged: (value) {
                  setState(() => _value = value);
                },
              ),
              FastAmountSwitchField(
                onAmountValueChanged: (value) {
                  debugPrint('onAmountValueChanged $value');
                  setState(() => _amountValue = value);
                },
                onPercentValueChanged: (value) {
                  debugPrint('onPercentValueChanged $value');
                  setState(() => _percentValue = value);
                },
                onFieldTypeChanged: (value) {
                  debugPrint('onFieldTypeChanged $value');
                  setState(() => _fieldType = value);
                },
                percentValue: _percentValue,
                amountValue: _amountValue,
                fieldType: _fieldType,
              ),
            ]),
          ),
        )
      ],
    );
  }
}
