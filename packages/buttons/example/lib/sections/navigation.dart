// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class NavigationButtonsSection extends StatelessWidget {
  const NavigationButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Navigation Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [
            FastBackButton(
              onTap: () {
                FastNotificationCenter.info(context, 'Back button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastCloseButton(
              size: FastButtonSize.small,
              onTap: () {
                FastNotificationCenter.info(context, 'Close button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastCloseButton(
              size: FastButtonSize.medium,
              onTap: () {
                FastNotificationCenter.info(context, 'Close button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastCloseButton(
              size: FastButtonSize.large,
              onTap: () {
                FastNotificationCenter.info(context, 'Close button tapped');
              },
            ),
          ],
        ),
      ],
    );
  }
}
