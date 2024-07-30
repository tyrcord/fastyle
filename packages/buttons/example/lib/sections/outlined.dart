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
          runSpacing: 6,
          children: [
            FastOutlinedButton(
              labelText: 'Border',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
