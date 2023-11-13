// Flutter imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:tbloc/tbloc.dart';
import 'package:fastyle_text/fastyle_text.dart';

class FastCalculatorLastUpdatedText extends StatelessWidget {
  static const String metatataKey = 'updatedOn';

  final FastCalculatorBloc bloc;
  final String? labelText;

  const FastCalculatorLastUpdatedText({
    super.key,
    required this.bloc,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      debugLabel: 'FastCalculatorLastUpdatedText',
      builder: buildControl,
      buildWhen: buildWhen,
      bloc: bloc,
    );
  }

  @protected
  bool buildWhen(
    FastCalculatorBlocState previous,
    FastCalculatorBlocState next,
  ) {
    final previousValue = previous.metadata[metatataKey];
    final nextValue = next.metadata[metatataKey];

    return nextValue != previousValue;
  }

  @protected
  Widget buildControl(
    BuildContext context,
    FastCalculatorBlocState state,
  ) {
    final date = state.metadata[metatataKey] as String?;

    if (date == null || date.isEmpty || state.isBusy) {
      return const SizedBox.shrink();
    }

    return FastLastUpdatedText(date: date, labelText: labelText);
  }
}
