// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class FastVideoVolumeButton extends StatefulWidget {
  final VideoPlayerController controller;
  final Widget? volumeIcon;
  final Widget? muteIcon;

  const FastVideoVolumeButton({
    super.key,
    required this.controller,
    this.volumeIcon,
    this.muteIcon,
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

  void handleVolumeChange() {
    setState(() {
      volume = volume == 0 ? 1.0 : 0;
      widget.controller.setVolume(volume);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return GestureDetector(
      onTap: handleVolumeChange,
      child: FastRoundedIcon(
        icon: volume == 0 ? buildMuteIcon(context) : buildVolumeIcon(context),
        backgroundColor: palette.darkest.withOpacity(0.5),
        iconColor: palette.ultraLight,
        size: kFastIconSizeMedium,
      ),
    );
  }

  Widget buildMuteIcon(BuildContext context) {
    if (widget.muteIcon != null) {
      return widget.muteIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightVolumeXmark);
    }

    return const FaIcon(FontAwesomeIcons.volumeXmark);
  }

  Widget buildVolumeIcon(BuildContext context) {
    if (widget.volumeIcon != null) {
      return widget.volumeIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightVolumeHigh);
    }

    return const FaIcon(FontAwesomeIcons.volumeHigh);
  }
}
