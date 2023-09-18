import 'package:matex_data/matex_data.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

class FastMatexCountryBuilder extends StatelessWidget {
  final Widget Function(BuildContext, MatexCountryBlocState) builder;
  final MatexCountryBloc bloc;

  const FastMatexCountryBuilder({
    super.key,
    required this.bloc,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) => previous.countries != next.countries,
      bloc: bloc,
      builder: builder,
    );
  }
}
