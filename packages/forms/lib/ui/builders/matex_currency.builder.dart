import 'package:matex_financial/financial.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

class FastMatexCurrencyBuilder extends StatelessWidget {
  final Widget Function(BuildContext, MatexCurrencyBlocState) builder;
  final MatexCurrencyBloc currencyBloc;

  const FastMatexCurrencyBuilder({
    super.key,
    required this.currencyBloc,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.currencies != next.currencies,
      bloc: currencyBloc,
      builder: builder,
    );
  }
}
