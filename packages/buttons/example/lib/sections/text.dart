import 'package:flutter/material.dart';
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class TextButtonsSection extends StatefulWidget {
  const TextButtonsSection({super.key});

  @override
  State<TextButtonsSection> createState() => _TextButtonsSectionState();
}

class _TextButtonsSectionState extends State<TextButtonsSection> {
  bool _isEnabled = true;

  void _toggleEnabled() {
    setState(() => _isEnabled = !_isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Text Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [
            FastTextButton2(
              size: FastButtonSize.small,
              labelText: 'Small',
              onTap: () {
                FastNotificationCenter.info(context, 'Small button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              size: FastButtonSize.medium,
              labelText: 'Medium',
              onTap: () {
                FastNotificationCenter.info(context, 'Medium button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              size: FastButtonSize.large,
              labelText: 'Large',
              onTap: () {
                FastNotificationCenter.info(context, 'Large button tapped');
              },
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'Disabled',
              onTap: () {},
              isEnabled: false,
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'Custom Style',
              textStyle: TextStyle(
                color: ThemeHelper.colors.getPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
              onTap: () {},
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'Toggle',
              onTap: _toggleEnabled,
              isEnabled: _isEnabled,
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'Uppercase',
              upperCase: true,
              onTap: () {},
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
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
