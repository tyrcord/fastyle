// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_video_player/fastyle_video_player.dart';

class FastVideoReplayCover extends StatelessWidget {
  final VoidCallback? onReplayTap;

  const FastVideoReplayCover({super.key, this.onReplayTap});

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.gray;

    return ColoredBox(
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
