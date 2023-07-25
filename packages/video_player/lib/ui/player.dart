import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_video_player/fastyle_video_player.dart';

class FastVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FastVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<FastVideoPlayer> createState() => _FastVideoPlayerState();
}

class _FastVideoPlayerState extends State<FastVideoPlayer> {
  // TODO: add error handling
  late VideoPlayerController _controller;
  late Future<void> _initialization;
  late Key _key;
  bool hasPlayed = false;
  double volume = 0;

  @override
  void initState() {
    super.initState();

    final uri = Uri.parse(widget.videoUrl);
    _controller = VideoPlayerController.networkUrl(uri);
    _controller.setVolume(volume);
    _controller.addListener(handleVideoPlay);
    _initialization = _controller.initialize();
    _key = UniqueKey();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(handleVideoPlay);
    _controller.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    _resetVideoController();
  }

  handleVideoPlay() {
    if (_controller.value.duration > Duration.zero) {
      if (_controller.value.position == _controller.value.duration) {
        debugPrint('Video has ended');

        setState(() {
          if (mounted) {
            _resetVideoController();
            hasPlayed = true;
          }
        });
      }
    }
  }

  void handleReplayAction() {
    setState(() {
      if (mounted) {
        debugPrint('Replaying video');
        hasPlayed = false;
        _controller.play();
      }
    });
  }

  void handleVisibilityChanged(VisibilityInfo info) {
    if (!hasPlayed) {
      if (info.visibleFraction >= 0.75) {
        debugPrint('Video is visible, playing');
        _controller.play();
      } else {
        debugPrint('Video is not visible, pausing');
        _controller.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _controller.value.isInitialized) {
          return VisibilityDetector(
            key: _key,
            onVisibilityChanged: handleVisibilityChanged,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  buildVideoControls(),
                  if (hasPlayed)
                    Positioned.fill(
                      child: FastVideoReplayCover(
                        onReplayTap: handleReplayAction,
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        // FIXME: add a placeholder
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildVideoControls() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: kFastEdgeInsets6,
        child: FastVideoVolumeButton(controller: _controller),
      ),
    );
  }

  void _resetVideoController() {
    hasPlayed = false;
    volume = 0;
    _controller.setVolume(0);
    _controller.seekTo(Duration.zero);
  }
}
