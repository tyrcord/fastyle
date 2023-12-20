// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_calculator/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

class FastCalculatorInstructionsOverlay extends StatelessWidget {
  final FastPaletteScheme? palette;
  final Widget? content;
  final String? titleText;

  const FastCalculatorInstructionsOverlay({
    super.key,
    this.palette,
    this.content,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return FastAlertDialog(
      titleText:
          titleText ?? CalculatorLocaleKeys.calculator_title_instructions.tr(),
      validText: CoreLocaleKeys.core_label_ok.tr(),
      onValid: () => Navigator.pop(context),
      children: content != null ? [content!] : null,
    );
  }
}
