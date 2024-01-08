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

    final item = kFastSettingsItemDescriptors[value]!;
    final defaultLabelText = item.labelText;

    return kFastSettingsItemDescriptors[value]!.copyWith(
      descriptor: buildListItemDescriptor(context, item, value),
      labelText: labelText ?? defaultLabelText.tr(),
      value: valueText,
    );
  }

  static FastListItemDescriptor buildListItemDescriptor(
    BuildContext context,
    FastItem<String> item,
    FastSettingsItems value,
  ) {
    assert(kFastSettingsItemIcons[value] != null);

    final useProIcons = FastIconHelper.of(context).useProIcons;
    final icons = kFastSettingsItemIcons[value]!;
    final scaleFactor = MediaQuery.maybeTextScalerOf(context);
    final iconSize = scaleFactor?.scale(kFastIconSizeSmall);
    final icon = SizedBox(
      width: iconSize,
      child: FaIcon(
        useProIcons ? icons.pro : icons.free,
        size: iconSize ?? kFastIconSizeSmall,
      ),
    );

    if (item.descriptor == null) {
      return FastListItemDescriptor(leading: icon);
    }

    return item.descriptor!.copyWith(leading: icon);
  }
}
