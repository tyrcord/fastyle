// Flutter imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
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
    return FastPopupMenuButton2<T>(
      iconColor: ThemeHelper.texts.getBodyTextStyle(context).color,
      itemBuilder: (BuildContext context) => options,
      onSelected: onOptionChanged,
      size: FastButtonSize.small,
      icon: buildIcon(context),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) return icon!;

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightEllipsisVertical);
    }

    return const FaIcon(FontAwesomeIcons.ellipsisVertical);
  }
}
