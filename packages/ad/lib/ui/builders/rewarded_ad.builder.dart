// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBuilder extends StatelessWidget {
  final BlocBuilder<FastRewardedAdBlocState> builder;
  final bool onlyWhenLoading;

  const FastRewardedAdBuilder({
    super.key,
    required this.builder,
    bool? onlyWhenLoading,
  }) : onlyWhenLoading = onlyWhenLoading ?? false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: BlocProvider.of<FastRewardedAdBloc>(context),
      buildWhen: buildWhen,
      builder: builder,
    );
  }

  bool buildWhen(
    FastRewardedAdBlocState previous,
    FastRewardedAdBlocState next,
  ) {
    if (onlyWhenLoading) {
      return previous.isLoadingAd != next.isLoadingAd;
    }

    return previous.isLoadingAd != next.isLoadingAd ||
        previous.hasError != next.hasError ||
        previous.hasDismissedAd != next.hasDismissedAd;
  }
}
