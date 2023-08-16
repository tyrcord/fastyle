import 'package:fastyle_core/logic/logic.dart';
import 'package:fastyle_core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';
import 'package:easy_localization/easy_localization.dart';

class FastExampleBlock extends StatelessWidget {
  final String example;

  const FastExampleBlock({
    super.key,
    required this.example,
  });

  @override
  Widget build(BuildContext context) {
    final palettes = ThemeHelper.getPaletteColors(context);
    final palette = palettes.blueGray;

    return BlocBuilderWidget(
      bloc: BlocProvider.of<FastThemeBloc>(context),
      builder: (BuildContext context, state) {
        final isDark = state.brightness == Brightness.dark;
        final backgroundColor = isDark ? palette.ultraDark : palette.ultraLight;
        final textColor = isDark ? palette.light : palette.dark;

        return Container(
          padding: kFastEdgeInsets16,
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FastSubtitle(
                text: CoreLocaleKeys.core_message_example.tr(),
                fontSize: kFastFontSize14,
                textColor: textColor,
              ),
              FastParagraph(
                fontSize: kFastFontSize14,
                textColor: textColor,
                text: example,
              ),
            ],
          ),
        );
      },
    );
  }
}
