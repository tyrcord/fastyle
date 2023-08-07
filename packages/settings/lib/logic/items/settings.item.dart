// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_settings/fastyle_settings.dart';

class FastSettingsItemIcon {
  final IconData pro;
  final IconData free;

  const FastSettingsItemIcon({
    required this.pro,
    required this.free,
  });
}

class FastSettingsItem {
  static FastItem<String> getItem(
    BuildContext context,
    FastSettingsItems value, {
    String? labelText,
    String? valueText,
  }) {
    assert(kFastSettingsItemDescriptors[value] != null);

    final defaultLabelText = kFastSettingsItemDescriptors[value]!.labelText;

    return kFastSettingsItemDescriptors[value]!.copyWith(
      descriptor: buildListItemDescriptor(context, value),
      labelText: labelText ?? defaultLabelText.tr(),
      value: valueText,
    );
  }

  static FastListItemDescriptor buildListItemDescriptor(
    BuildContext context,
    FastSettingsItems value,
  ) {
    assert(kFastSettingsItemIcons[value] != null);

    final useProIcons = FastIconHelper.of(context).useProIcons;
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final icons = kFastSettingsItemIcons[value]!;

    return FastListItemDescriptor(
      leading: FaIcon(
        useProIcons ? icons.pro : icons.free,
        size: kFastIconSizeSmall * scaleFactor,
      ),
    );
  }
}
