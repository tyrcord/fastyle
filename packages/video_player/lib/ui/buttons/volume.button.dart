// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class FastVideoVolumeButton extends StatefulWidget {
  final VideoPlayerController controller;

  const FastVideoVolumeButton({
    super.key,
    required this.controller,
  });

  @override
  FastVideoVolumeButtonState createState() => FastVideoVolumeButtonState();
}

class FastVideoVolumeButtonState extends State<FastVideoVolumeButton> {
  double volume = 1.0;

  @override
  void initState() {
    super.initState();
    volume = widget.controller.value.volume;
  }

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return GestureDetector(
      child: FastRoundedIcon(
        backgroundColor: palette.darkest.withOpacity(0.5),
        size: kFastIconSizeMedium,
        iconColor: palette.ultraLight,
        icon: FaIcon(
          volume == 0
              ? FontAwesomeIcons.volumeXmark
              : FontAwesomeIcons.volumeHigh,
        ),
      ),
      onTap: () {
        setState(() {
          volume = volume == 0 ? 1.0 : 0;
          widget.controller.setVolume(volume);
        });
      },
    );
  }
}
