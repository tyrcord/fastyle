// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:matex_financial/financial.dart';
import 'package:tbloc/tbloc.dart';

class FastMatexCurrencyBuilder extends StatelessWidget {
  final Widget Function(BuildContext, MatexCurrencyBlocState) builder;
  final MatexCurrencyBloc bloc;

  const FastMatexCurrencyBuilder({
    super.key,
    required this.bloc,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.currencies != next.currencies,
      bloc: bloc,
      builder: builder,
    );
  }
}
