// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictBuilder extends StatelessWidget {
  final BlocBuilder<FastAppDictBlocState> builder;
  final String dataKey;

  const FastAppDictBuilder({
    super.key,
    required this.builder,
    required this.dataKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        final previousValue = previous.getValue(dataKey);
        final nextValue = next.getValue(dataKey);

        return previousValue != nextValue;
      },
      bloc: FastAppDictBloc.instance,
      builder: builder,
    );
  }
}
