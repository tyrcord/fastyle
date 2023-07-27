// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdmobRewardedAdBuilder extends StatelessWidget {
  final BlocBuilder<FastRewardedAdBlocState> builder;

  const FastAdmobRewardedAdBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

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
    return previous.isLoadingAd != next.isLoadingAd ||
        previous.isRewarded != next.isRewarded ||
        previous.hasError != next.hasError ||
        previous.hasDismissedAd != next.hasDismissedAd ||
        previous.showFallback != next.showFallback;
  }
}
