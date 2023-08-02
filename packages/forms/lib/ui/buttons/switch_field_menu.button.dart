// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastSwitchFieldMenuButton<T> extends StatelessWidget {
  final List<PopupMenuItem<T>> options;
  final Function(T) onOptionChanged;

  final Widget? icon;

  const FastSwitchFieldMenuButton({
    super.key,
    required this.options,
    required this.onOptionChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FastPopupMenuButton<T>(
      itemBuilder: (BuildContext context) => options,
      iconAlignment: Alignment.centerRight,
      onSelected: onOptionChanged,
      padding: EdgeInsets.zero,
      icon: buildIcon(context),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return FaIcon(
        FastFontAwesomeIcons.lightEllipsisVertical,
        color: ThemeHelper.texts.getBodyTextStyle(context).color,
        size: kFastIconSizeSmall,
      );
    }

    return FaIcon(
      FontAwesomeIcons.ellipsisVertical,
      color: ThemeHelper.texts.getBodyTextStyle(context).color,
      size: kFastIconSizeSmall,
    );
  }
}
