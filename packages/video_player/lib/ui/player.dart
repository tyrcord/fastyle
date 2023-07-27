import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_video_player/fastyle_video_player.dart';

class FastVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final Widget? badge;

  const FastVideoPlayer({
    super.key,
    required this.videoUrl,
    this.badge,
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
    _controller.addListener(handleVideoPositionChange);
    _key = UniqueKey();

    _initialization = _controller.initialize().then((value) {
      return _controller.setVolume(volume);
    });
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _controller.removeListener(handleVideoPositionChange);
    await _controller.pause();
    await _controller.dispose();
  }

  Future<void> handleVideoPositionChange() async {
    if (mounted && _controller.value.duration > Duration.zero) {
      if (_controller.value.position == _controller.value.duration) {
        debugPrint('Video has ended');

        await _resetVideoController();

        setState(() {
          if (mounted) {
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

  Future<void> handleVisibilityChanged(VisibilityInfo info) async {
    if (!hasPlayed && mounted) {
      if (info.visibleFraction >= 0.75) {
        debugPrint('Video is visible, playing');

        return _controller.play();
      }

      debugPrint('Video is not visible, pausing');

      return _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_controller.value.hasError) {
            final palettes = ThemeHelper.getPaletteColors(context);
            final color = palettes.red.mid;

            return FastBoxPlaceholder(
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.videoSlash,
                  color: color,
                ),
              ),
            );
          } else if (_controller.value.isInitialized) {
            return buildVideoPlayer();
          }
        }

        return const FastLoadingBoxPlaceholder();
      },
    );
  }

  Widget buildVideoPlayer() {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: handleVisibilityChanged,
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_controller),
            buildVideoPlayerControls(),
            if (hasPlayed)
              Positioned.fill(
                child: FastVideoReplayCover(onReplayTap: handleReplayAction),
              ),
            if (widget.badge != null)
              Positioned(
                top: 0,
                left: 0,
                child: widget.badge!,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoPlayerControls() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: kFastEdgeInsets6,
        child: FastVideoVolumeButton(controller: _controller),
      ),
    );
  }

  Future<void> _resetVideoController() async {
    hasPlayed = false;
    volume = 0;

    if (mounted) {
      await _controller.setVolume(volume);

      return _controller.seekTo(Duration.zero);
    }
  }
}
