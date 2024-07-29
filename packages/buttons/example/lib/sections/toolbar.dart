// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';

class ToolbarButtonsSection extends StatelessWidget {
  const ToolbarButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Toolbar Buttons'),
        kFastVerticalSizedBox12,
        Row(
          children: [
            FastToolBarButton(
              icon: const FaIcon(FontAwesomeIcons.folderOpen),
              labelText: 'Open folder',
              onTap: () {
                FastNotificationCenter.info(
                  context,
                  'Open folder button tapped',
                );
              },
            ),
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              icon: const FaIcon(FontAwesomeIcons.floppyDisk),
              labelText: 'Save',
              onTap: () {
                FastNotificationCenter.info(context, 'Save button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              icon: const FaIcon(FontAwesomeIcons.trash),
              labelText: 'Delete',
              isEnabled: false,
              onTap: () {
                FastNotificationCenter.info(context, 'Delete button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              iconColor: ThemeHelper.colors.getPrimaryColor(context),
              icon: const FaIcon(FontAwesomeIcons.print),
              labelText: 'Print',
              onTap: () {
                FastNotificationCenter.info(context, 'Print button tapped');
              },
            ),
          ],
        ),
      ],
    );
  }
}
