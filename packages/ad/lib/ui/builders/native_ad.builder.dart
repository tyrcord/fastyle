// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBuilder extends StatelessWidget {
  final BlocBuilder<FastNativeAdBlocState> builder;
  final FastNativeAdBloc bloc;

  const FastNativeAdBuilder({
    Key? key,
    required this.builder,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: buildWhen,
      builder: builder,
      bloc: bloc,
    );
  }

  bool buildWhen(FastNativeAdBlocState previous, FastNativeAdBlocState next) {
    return previous.isLoadingAd != next.isLoadingAd ||
        previous.showFallback != next.showFallback;
  }
}
