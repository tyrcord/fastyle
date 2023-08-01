// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSelectableListItem<T extends FastItem> extends StatelessWidget {
  final EdgeInsets? contentPadding;

  ///
  /// Allow to convert the label to beginning of sentence case.
  ///
  final Color? selectionTralingColor;
  final Color? selectionLabelColor;
  final bool capitalizeLabelText;
  final String? descriptionText;
  final Color? selectionColor;
  final VoidCallback onTap;
  final String? labelText;
  final Widget? trailing;
  final bool isSelected;
  final Widget? leading;
  final bool isEnabled;
  final bool isDense;
  final T? item;

  FastSelectableListItem({
    super.key,
    required this.onTap,
    this.capitalizeLabelText = true,
    this.isSelected = false,
    this.isEnabled = true,
    this.isDense = true,
    this.selectionTralingColor,
    this.selectionLabelColor,
    this.descriptionText,
    this.contentPadding,
    this.selectionColor,
    this.labelText,
    this.trailing,
    this.leading,
    this.item,
  })  : assert(item?.labelText != null || labelText != null);

  @override
  Widget build(BuildContext context) {
    final descriptor = item?.descriptor;
    Color? selectionLabelColor0 = descriptor?.selectionLabelColor;
    Color? selectionColor0 = descriptor?.selectionColor;
    Widget? trailing0;

    if (isSelected) {
      final palette = ThemeHelper.getPaletteColors(context);
      final colors = ThemeHelper.colors;

      if (selectionColor != null) {
        selectionColor0 ??= selectionColor ?? colors.getPrimaryColor(context);
        selectionLabelColor0 ??= selectionLabelColor ?? palette.whiteColor;
        trailing0 = null;
      } else {
        trailing0 = _buildTrailingIcon(context);
      }
    }

    return FastListItemLayout(
      contentPadding: descriptor?.padding ?? contentPadding,
      descriptionText: item?.descriptionText ?? descriptionText,
      leading: descriptor?.leading ?? leading,
      isDense: descriptor?.isDense ?? isDense,
      selectionLabelColor: selectionLabelColor0,
      labelText: item?.labelText ?? labelText!,
      capitalizeLabelText: capitalizeLabelText,
      isEnabled: item?.isEnabled ?? isEnabled,
      selectionColor: selectionColor0,
      trailing: trailing0,
      onTap: onTap,
    );
  }

  Widget _buildTrailingIcon(BuildContext context) {
    var icon = item?.descriptor?.trailing ?? trailing ?? kFastDoneIcon;

    if (icon is Icon) {
      icon = Icon(
        color: _getSelectionTrailingColor(context),
        size: icon.size,
        icon.icon,
      );
    } else if (icon is FaIcon) {
      icon = FaIcon(
        icon.icon,
        color: _getSelectionTrailingColor(context),
        size: icon.size,
      );
    }

    return icon;
  }

  Color _getSelectionTrailingColor(BuildContext context) {
    final colors = ThemeHelper.colors;

    return selectionTralingColor ?? colors.getPrimaryColor(context);
  }
}
