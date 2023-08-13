// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class FastGoodbyeAdLink extends StatelessWidget {
  final String? linkText;
  final String? prefixText;
  final Color? linkColor;
  final VoidCallback? onTap;

  const FastGoodbyeAdLink({
    super.key,
    this.linkText,
    this.prefixText,
    this.linkColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FastRichTextLink(
      prefixText: prefixText ?? AdLocaleKeys.ad_message_say_goodbye_to_ads.tr(),
      linkText: linkText ?? PurchasesLocaleKeys.purchases_label_go_premium.tr(),
      onTap: onTap,
    );
  }
}
