// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:fastyle_core/fastyle_core.dart';

class PendingButtonsSection extends StatefulWidget {
  const PendingButtonsSection({super.key});

  @override
  State<PendingButtonsSection> createState() => _PendingButtonsSectionState();
}

class _PendingButtonsSectionState extends State<PendingButtonsSection> {
  bool _isPending = false;

  void _togglePending() {
    setState(() => _isPending = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isPending = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FastBody(text: 'Pending Buttons'),
        kFastVerticalSizedBox12,
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 6,
          children: [
            FastPendingOutlinedButton(
              labelText: 'Outlined button',
              onTap: _togglePending,
              isPending: _isPending,
            ),
            kFastHorizontalSizedBox12,
            FastPendingRaisedButton(
              labelText: 'Raised button',
              onTap: _togglePending,
              isPending: _isPending,
            ),
            kFastHorizontalSizedBox12,
            FastPendingRaisedButton(
              labelText: 'With Tooltip',
              tooltip: 'This is a tooltip',
              onTap: _togglePending,
              isPending: _isPending,
            ),
            kFastHorizontalSizedBox12,
            FastPendingRaisedButton(
              labelText: 'Red',
              color: Colors.red[300],
              onTap: _togglePending,
              isPending: _isPending,
            ),
            kFastHorizontalSizedBox12,
          ],
        ),
      ],
    );
  }
}
