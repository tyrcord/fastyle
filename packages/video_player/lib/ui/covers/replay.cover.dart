import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_video_player/fastyle_video_player.dart';

class FastVideoReplayCover extends StatelessWidget {
  final VoidCallback? onReplayTap;

  const FastVideoReplayCover({super.key, this.onReplayTap});

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return Container(
      color: palette.ultraDark.withOpacity(0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FastSecondaryBody(
            fontWeight: kFastFontWeightMedium,
            text: CoreLocaleKeys.core_label_replay.tr(),
            textColor: palette.ultraLight,
          ),
          kFastVerticalSizedBox8,
          FastVideoReplayButton(onTap: onReplayTap),
        ],
      ),
    );
  }
}
