//FastPlanBloc

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

typedef FastIapPlanBuilderCallBack = bool Function(
  FastPlanBlocState context,
  FastPlanBlocState state,
);

class FastIapPlanBuilder extends StatelessWidget {
  final BlocBuilder<FastPlanBlocState> builder;
  final FastIapPlanBuilderCallBack? buildWhen;
  final bool onlyWhenIsRestoringPlanChanges;
  final bool onlyWhenPurchaseChanges;

  const FastIapPlanBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
    this.onlyWhenIsRestoringPlanChanges = false,
    this.onlyWhenPurchaseChanges = false,
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
    if (next.hasError) {
      return true;
    }

    if (buildWhen != null) {
      return buildWhen!.call(previous, next);
    }

    if (onlyWhenIsRestoringPlanChanges) {
      return previous.isRestoringPlan != next.isRestoringPlan;
    }

    if (onlyWhenPurchaseChanges) {
      return previous.isPlanPurcharsePending != next.isPlanPurcharsePending;
    }

    return true;
  }
}
