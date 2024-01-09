// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_settings/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

FastItem<String> buildAdConsentSettingItem(
  BuildContext context, {
  String? labelText,
}) {
  const size = kFastIconSizeSmall;
  final scaleFactor = MediaQuery.maybeTextScalerOf(context);
  final iconSize = scaleFactor?.scale(size) ?? size;

  return FastItem(
    descriptor: FastListItemDescriptor(
      trailing: const SizedBox.shrink(),
      leading: SizedBox(
        width: iconSize,
        child: FaIcon(
          FastFontAwesomeIcons.lightShieldCheck,
          size: iconSize,
        ),
      ),
    ),
    labelText:
        labelText ?? SettingsLocaleKeys.settings_label_privacy_preferences.tr(),
    onTap: (value) => showConsentForm(),
  );
}
