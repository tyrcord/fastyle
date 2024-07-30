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
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
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
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              size: FastButtonSize.small,
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
              labelText: 'Small',
              onTap: () {
                FastNotificationCenter.info(context, 'Small button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              size: FastButtonSize.medium,
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
              labelText: 'Medium',
              onTap: () {
                FastNotificationCenter.info(context, 'Medium button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastToolBarButton(
              size: FastButtonSize.large,
              icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
              labelText: 'Large',
              onTap: () {
                FastNotificationCenter.info(context, 'Large button tapped');
              },
            ),
          ],
        ),
      ],
    );
  }
}
