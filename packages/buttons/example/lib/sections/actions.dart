// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class ActionButtonsSection extends StatefulWidget {
  const ActionButtonsSection({super.key});

  @override
  State<ActionButtonsSection> createState() => _ActionButtonsSectionState();
}

class _ActionButtonsSectionState extends State<ActionButtonsSection> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Action buttons'),
        kFastVerticalSizedBox12,
        Row(
          children: [
            const FastCopyButton(valueText: '42'),
            kFastHorizontalSizedBox12,
            FastFavoriteIconButton(
              isFavorite: _isFavorite,
              onTap: _toggleFavorite,
            ),
            kFastHorizontalSizedBox12,
            FastFavoriteIconButton(
              onTap: _toggleFavorite,
              isFavorite: false,
              isEnabled: false,
            ),
          ],
        ),
      ],
    );
  }
}
