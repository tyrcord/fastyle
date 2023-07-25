import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_video_player/fastyle_video_player.dart';

class FastVideoNativeAd extends StatelessWidget {
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final FastAdSize adSize;
  final String? titleText;
  final String? buttonText;
  final bool loading;
  final String videoUrl;

  const FastVideoNativeAd({
    super.key,
    this.adSize = FastAdSize.large, // TODO
    required this.videoUrl,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FastNativeAdLayout(
      icon: FastVideoPlayer(videoUrl: videoUrl),
      descriptionText: descriptionText,
      onButtonTap: onButtonTap,
      buttonText: buttonText,
      titleText: titleText,
      adSize: adSize,
    );
  }
}
