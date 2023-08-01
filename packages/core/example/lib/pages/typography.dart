// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final palette = ThemeHelper.getPaletteColors(context);

    return FastSectionPage(
      titleText: 'Typography',
      child: ListView(
        children: [
          const FastDisplay(text: 'Display'),
          kFastSizedBox16,
          const FastDisplay(text: '\$28,000'),
          kFastSizedBox16,
          const FastHeadline(text: 'Headline'),
          kFastSizedBox16,
          const FastPlaceHolderHeadline(text: 'Placeholder Headline'),
          kFastSizedBox16,
          const FastSubhead(text: 'Subhead'),
          kFastSizedBox16,
          const FastTitle(text: 'Title'),
          kFastSizedBox16,
          const FastPlaceholderTitle(text: 'Placeholder Title'),
          kFastSizedBox16,
          const FastSubtitle(text: 'Subtitle'),
          kFastSizedBox16,
          const FastSecondarySubtitle(text: 'Secondary Subtitle'),
          kFastSizedBox16,
          const FastBody(text: 'Body'),
          kFastSizedBox16,
          const FastSecondaryBody(text: 'Secondary Body'),
          kFastSizedBox16,
          const FastBody(text: '\$28,000'),
          kFastSizedBox16,
          const FastPlaceholder(text: 'Placeholder'),
          kFastSizedBox16,
          const FastButtonLabel(text: 'Button'),
          kFastSizedBox16,
          const FastSecondaryButton(text: 'Secondary Button'),
          kFastSizedBox16,
          const FastCaption(text: 'Caption'),
          kFastSizedBox16,
          const FastSecondaryCaption(text: 'Secondary Caption'),
          kFastSizedBox16,
          const FastOverline(text: 'Overline'),
          kFastSizedBox16,
          const FastSecondaryOverline(text: 'Secondary Overline'),
          kFastSizedBox16,
          FastLink(
            onTap: () => log('link tapped'),
            text: 'link',
          ),
          FastParagraph(
            child: RichText(
              text: TextSpan(
                style: bodyTextStyle,
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                    'Cras pulvinar enim sit amet odio eleifend, id sagittis '
                    'massa tincidunt. Phasellus justo ligula, imperdiet ut '
                    'pretium ac, suscipit non sem. ',
                children: [
                  TextSpan(
                    style: bodyTextStyle.copyWith(color: palette.blue.mid),
                    text: 'nested link',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
