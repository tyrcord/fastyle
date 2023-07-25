// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastNativeAdBuilder extends StatelessWidget {
  final BlocBuilder<FastNativeAdBlocState> builder;

  const FastNativeAdBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        return previous.isLoadingAd != next.isLoadingAd ||
            previous.showCustomAd != next.showCustomAd;
      },
      bloc: BlocProvider.of<FastNativeAdBloc>(context),
      builder: builder,
    );
  }
}
