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
          runSpacing: 6,
          children: [
            FastRaisedButton2(
              labelText: 'Colored',
              onTap: () {
                FastNotificationCenter.info(context, 'Colored button tapped');
              },
            ),
          ],
        ),
      ],
    );
  }
}
