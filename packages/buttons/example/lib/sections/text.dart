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
          runSpacing: 6,
          children: [
            FastTextButton2(
              labelText: 'Default',
              onTap: () {},
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'Disabled',
              onTap: () {},
              isEnabled: false,
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
              labelText: 'Custom Style',
              textStyle: TextStyle(
                color: ThemeHelper.colors.getPrimaryColor(context),
                fontWeight: FontWeight.bold,
              ),
              onTap: () {},
            ),
            kFastHorizontalSizedBox12,
            FastTextButton2(
              labelText: 'With Tooltip',
              tooltip: 'This is a tooltip',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
