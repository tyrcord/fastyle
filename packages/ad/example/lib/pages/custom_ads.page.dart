import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class CustomAdsPage extends StatefulWidget {
  const CustomAdsPage({super.key});

  @override
  State<CustomAdsPage> createState() => _CustomAdsPageState();
}

class _CustomAdsPageState extends State<CustomAdsPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          // TODO: play & pause when the widget become visible/invisible
          _controller.play();

          // TODO:add cover when video has finished
          print('add listener');

          _controller.addListener(() {
            print(_controller.value.position);

            if (_controller.value.position == _controller.value.duration) {
              print('video has finished');
              // add cover with replay button
              // _controller.seekTo(const Duration());
              // _controller.play();
            }
          });
          // TODO: add sound button
          _controller.setVolume(0);
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                'I also have a long description. I also have a long description.',
          ),
          kFastSizedBox16,
          const FastTitle(text: 'Large Video Custom Ad'),
          kFastSizedBox16,
          FastNativeAdLayout(
            adSize: FastAdSize.large,
            titleText: 'Large Ad',
            icon: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
            descriptionText: 'This is a large ad with a custom icon and '
                'an install button. It also has a long description.'
                'I also have a long description. I also have a long description.',
          ),
        ],
      ),
    );
  }
}
