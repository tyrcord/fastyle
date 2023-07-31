//FastPlanBloc

// Flutter imports:
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

typedef FastIapPlanBuilderCallBack = bool Function(
  FastPlanBlocState context,
  FastPlanBlocState state,
);

class FastIapPlanBuilder extends StatelessWidget {
  final BlocBuilder<FastPlanBlocState> builder;
  final FastIapPlanBuilderCallBack? buildWhen;

  const FastIapPlanBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: BlocProvider.of<FastPlanBloc>(context),
      buildWhen: _shouldBuild,
      builder: builder,
    );
  }

  bool _shouldBuild(FastPlanBlocState previous, FastPlanBlocState next) {
    if (buildWhen != null) {
      return buildWhen!.call(previous, next);
    }

    return true;
  }
}
