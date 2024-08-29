// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class OutlinedButtonsSection extends StatelessWidget {
  const OutlinedButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Outlined Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [
            FastOutlinedButton(
              size: FastButtonSize.small,
              labelText: 'Small',
              onTap: () {
                FastNotificationCenter.info(context, 'Small button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastOutlinedButton(
              labelText: 'Medium',
              onTap: () {
                FastNotificationCenter.info(context, 'Medium button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastOutlinedButton(
              size: FastButtonSize.large,
              labelText: 'Large',
              onTap: () {
                FastNotificationCenter.info(context, 'Large button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            const FastOutlinedButton(
              labelText: 'Disabled',
              isEnabled: false,
            ),
            kFastHorizontalSizedBox12,
            FastOutlinedButton(
              textColor: Colors.red[300],
              labelText: 'Red',
              onTap: () {
                FastNotificationCenter.info(context, 'Red button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastOutlinedButton(
              labelText: 'With Tooltip',
              tooltip: 'This is a tooltip',
              onTap: () {},
            ),
            kFastHorizontalSizedBox12,
          ],
        ),
      ],
    );
  }
}
