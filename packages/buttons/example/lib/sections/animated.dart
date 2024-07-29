// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class AnimatedButtonsSection extends StatefulWidget {
  const AnimatedButtonsSection({super.key});

  @override
  State<AnimatedButtonsSection> createState() => _AnimatedButtonsSectionState();
}

class _AnimatedButtonsSectionState extends State<AnimatedButtonsSection> {
  bool _isRotating = false;

  void _toggleRotation() {
    setState(() => _isRotating = !_isRotating);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Animated Buttons'),
        kFastVerticalSizedBox12,
        Row(
          children: [
            FastAnimatedRotationIconButton2(
              iconColor: ThemeHelper.colors.getPrimaryColor(context),
              debugLabel: 'Blue animated button',
              onTap: _toggleRotation,
              rotate: _isRotating,
            ),
            kFastHorizontalSizedBox12,
            FastAnimatedRotationIconButton2(
              onTap: () {},
              rotate: false,
              isEnabled: false,
            ),
            kFastHorizontalSizedBox12,
            FastAnimatedRotationIconButton2(
              iconSize: kFastIconSizeMedium,
              onTap: _toggleRotation,
              rotate: _isRotating,
            ),
          ],
        ),
      ],
    );
  }
}
