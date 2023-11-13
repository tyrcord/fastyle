import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

class FastLastUpdatedText extends StatelessWidget {
  final String? labelText;
  final String date;

  const FastLastUpdatedText({
    super.key,
    required this.date,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return FastSecondaryBody(
      textAlign: TextAlign.center,
      text: _getLabelText(),
    );
  }

  String _getLabelText() {
    if (labelText != null) return labelText!;

    return CoreLocaleKeys.core_message_last_updated_on.tr(
      namedArgs: {'date': date},
    );
  }
}
