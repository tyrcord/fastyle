import 'dart:developer';

import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class TypographyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final palette = ThemeHelper.getPaletteColors(context);

    return FastSectionPage(
      titleText: 'Typography',
      child: ListView(
        children: [
          FastDisplay(text: 'Display'),
          kFastSizedBox16,
          FastDisplay(text: '\$28,000'),
          kFastSizedBox16,
          FastHeadline(text: 'Headline'),
          kFastSizedBox16,
          FastPlaceHolderHeadline(text: 'Placeholder Headline'),
          kFastSizedBox16,
          FastSubhead(text: 'Subhead'),
          kFastSizedBox16,
          FastTitle(text: 'Title'),
          kFastSizedBox16,
          FastPlaceholderTitle(text: 'Placeholder Title'),
          kFastSizedBox16,
          FastSubtitle(text: 'Subtitle'),
          kFastSizedBox16,
          FastSecondarySubtitle(text: 'Secondary Subtitle'),
          kFastSizedBox16,
          FastBody(text: 'Body'),
          kFastSizedBox16,
          FastSecondaryBody(text: 'Secondary Body'),
          kFastSizedBox16,
          FastBody(text: '\$28,000'),
          kFastSizedBox16,
          FastPlaceholder(text: 'Placeholder'),
          kFastSizedBox16,
          FastButtonLabel(text: 'Button'),
          kFastSizedBox16,
          FastSecondaryButton(text: 'Secondary Button'),
          kFastSizedBox16,
          FastCaption(text: 'Caption'),
          kFastSizedBox16,
          FastSecondaryCaption(text: 'Secondary Caption'),
          kFastSizedBox16,
          FastOverline(text: 'Overline'),
          kFastSizedBox16,
          FastSecondaryOverline(text: 'Secondary Overline'),
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
