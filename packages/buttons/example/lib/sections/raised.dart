// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class RaisedButtonsSection extends StatelessWidget {
  const RaisedButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Raised Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [
            FastRaisedButton2(
              size: FastButtonSize.small,
              labelText: 'Small',
              onTap: () {
                FastNotificationCenter.info(context, 'Small button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastRaisedButton2(
              labelText: 'Medium',
              onTap: () {
                FastNotificationCenter.info(context, 'Medium button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastRaisedButton2(
              size: FastButtonSize.large,
              labelText: 'Large',
              onTap: () {
                FastNotificationCenter.info(context, 'Large button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            const FastRaisedButton2(
              labelText: 'Disabled',
              isEnabled: false,
            ),
            kFastHorizontalSizedBox12,
            FastRaisedButton2(
              labelText: 'Red',
              color: Colors.red[300],
              onTap: () {
                FastNotificationCenter.info(context, 'Red button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastRaisedButton2(
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
