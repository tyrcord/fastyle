// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PopupMenuButtonsSection extends StatelessWidget {
  const PopupMenuButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Popup Menu Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          runSpacing: 6,
          children: [
            FastPopupMenuButton2(
              onSelected: (String value) {
                FastNotificationCenter.info(context, '$value selected');
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'One',
                  child: Text('One'),
                ),
                const PopupMenuItem(
                  value: 'Two',
                  child: Text('Two'),
                ),
                const PopupMenuItem(
                  value: 'Three',
                  child: Text('Three'),
                ),
              ],
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
            ),
          ],
        ),
      ],
    );
  }
}
