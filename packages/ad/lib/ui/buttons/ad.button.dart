import 'package:flutter/material.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

class FastAdButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;

  const FastAdButton({
    super.key,
    this.onTap,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FastRaisedButton(
      text: text ?? CoreLocaleKeys.core_label_install.tr(),
      onTap: handleButtonTap,
    );
  }

  void handleButtonTap() => onTap?.call();
}