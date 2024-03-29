// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_video_player/fastyle_video_player.dart';
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastVideoNativeAd extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? debugLabel;
  final String? buttonText;
  final FastAdSize adSize;
  final String? titleText;
  final String videoUrl;
  final double? rating;
  final bool loading;

  // ignore: prefer_const_constructors_in_immutables
  FastVideoNativeAd({
    super.key,
    this.adSize = FastAdSize.large,
    required this.videoUrl,
    this.descriptionText,
    this.onButtonTap,
    this.debugLabel,
    this.buttonText,
    this.titleText,
    this.rating,
    this.loading = false,
  }) : assert(adSize >= FastAdSize.medium);

  @override
  Widget build(BuildContext context) {
    return FastNativeAdLayout(
      icon: FastVideoPlayer(
        badge: const FastAdBadge(),
        videoUrl: videoUrl,
        debugLabel: debugLabel,
      ),
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      showAdBadge: false,
      adSize: adSize,
      ranking: rating,
    );
  }
}
