// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAdsPage extends StatefulWidget {
  const CustomAdsPage({super.key});

  @override
  State<CustomAdsPage> createState() => _CustomAdsPageState();
}

class _CustomAdsPageState extends State<CustomAdsPage> {
  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Custom Ads',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FastTitle(text: 'Small Custom Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.small,
            titleText: 'Medium Ad',
            rating: 4.5,
            icon: Container(
              color: Colors.blueGrey[100],
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.bullhorn,
                  color: Colors.blueGrey,
                  size: 24,
                ),
              ),
            ),
            descriptionText: 'This is a medium ad with a custom icon and '
                'an install button.',
          ),
          kFastSizedBox16,
          const FastTitle(text: 'Medium Custom Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.medium,
            titleText: 'Medium Ad',
            rating: 4,
            icon: Container(
              color: Colors.blueGrey[100],
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.bullhorn,
                  color: Colors.blueGrey,
                  size: 80,
                ),
              ),
            ),
            descriptionText: 'This is a medium ad with a custom icon and '
                'an install button.',
          ),
          kFastSizedBox16,
          const FastTitle(text: 'Large Custom Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.large,
            titleText: 'Large Ad',
            icon: Container(
              color: Colors.blueGrey[100],
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.bullhorn,
                  color: Colors.blueGrey,
                  size: 144,
                ),
              ),
            ),
            descriptionText: 'This is a large ad with a custom icon and '
                'an install button. It also has a long description.'
                'It also have a long description. '
                'It also have a long description.',
          ),
          kFastSizedBox16,
          const FastTitle(text: 'Medium Video Custom Ad'),
          kFastSizedBox16,
          FastVideoNativeAd(
            videoUrl: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
            adSize: FastAdSize.medium,
            titleText: 'Medium Video Ad',
            debugLabel: 'Medium Video Ad',
            descriptionText: 'This is a Medium ad with a Video and '
                'an install button. It also has a long description.'
                'It also have a long description. '
                'It also have a long description.',
          ),
          kFastSizedBox16,
          kFastSizedBox16,
          FastVideoNativeAd(
            videoUrl: 'https://samplelib.com',
            adSize: FastAdSize.medium,
            titleText: 'Medium Video Ad with error',
            descriptionText: 'This is a Medium ad with a Video and '
                'an install button. It also has a long description.'
                'It also have a long description. '
                'It also have a long description.',
          ),
          kFastSizedBox16,
          const FastTitle(text: 'Large Video Custom Ad'),
          kFastSizedBox16,
          FastVideoNativeAd(
            rating: 4,
            debugLabel: 'Large Video Ad',
            videoUrl:
                'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            adSize: FastAdSize.large,
            titleText: 'Large Video Ad',
            descriptionText: 'This is a large ad with a Video and '
                'an install button. It also has a long description.'
                'It also have a long description. '
                'It also have a long description.',
          ),
          kFastSizedBox16,
        ],
      ),
    );
  }
}
