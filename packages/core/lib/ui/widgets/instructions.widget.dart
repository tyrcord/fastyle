// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastInstructions extends StatelessWidget {
  final List<String> instructions;

  const FastInstructions({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: instructions.map(
          (instruction) {
            return Padding(
              padding: kFastEdgeInsets8,
              child: FastInstruction(text: instruction),
            );
          },
        ).toList(),
      ),
    );
  }
}

class FastInstruction extends StatelessWidget {
  final String text;

  const FastInstruction({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FastRoundedDuotoneIcon(
          palette: ThemeHelper.getPaletteColors(context).blueGray,
          icon: _getIcon(context),
          size: kFastIconSizeXs,
        ),
        kFastHorizontalSizedBox12,
        Expanded(child: FastSecondaryBody(text: text, maxLines: 2)),
      ],
    );
  }

  Widget _getIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightCheck);
    }

    return const FaIcon(FontAwesomeIcons.check);
  }
}
