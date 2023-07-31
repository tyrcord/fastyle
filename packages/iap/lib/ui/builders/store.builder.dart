//FastPlanBloc

// Flutter imports:
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

typedef FastStorePlanBuilderCallBack = bool Function(
  FastStoreBlocState context,
  FastStoreBlocState state,
);

class FastStorePlanBuilder extends StatelessWidget {
  final BlocBuilder<FastStoreBlocState> builder;
  final FastStorePlanBuilderCallBack? buildWhen;
  final bool onlyWhenProductsChnages;

  const FastStorePlanBuilder({
    super.key,
    required this.builder,
    this.onlyWhenProductsChnages = false,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: BlocProvider.of<FastStoreBloc>(context),
      buildWhen: _shouldBuild,
      builder: builder,
    );
  }

  bool _shouldBuild(FastStoreBlocState previous, FastStoreBlocState next) {
    if (buildWhen != null) {
      return buildWhen!.call(previous, next);
    }

    if (onlyWhenProductsChnages) {
      return previous.products != next.products;
    }

    return true;
  }
}
