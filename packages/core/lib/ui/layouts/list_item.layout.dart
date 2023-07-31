// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:


//TODO: @need-review: code from fastyle_dart

class FastListItemLayout extends StatelessWidget {
  /// Describes some additional visual aspects of an item.
  final FastListItemDescriptor? descriptor;

  /// The padding for the input decoration's container.
  final EdgeInsets? contentPadding;

  /// Allow to convert the label to beginning of sentence case.
  final bool capitalizeLabelText;

  /// Text that describes an item description.
  final String? descriptionText;

  /// Called for each distinct tap.
  final VoidCallback? onTap;

  /// Text that describes an item label.
  final String labelText;

  /// A widget to display after an item label.
  final Widget? trailing;

  /// A widget to display before an item label.
  final Widget? leading;

  /// Indicates whether an item is enabled in the user interface.
  final bool isEnabled;

  /// Specifies whether an item will have the vertically dense layout.
  final bool isDense;

  /// The color of the item label when it is selected.
  final Color? selectionLabelColor;

  /// The color of the item when it is selected.
  final Color? selectionColor;

  /// The minimum width for the leading widget.
  final double minLeadingWidth;

  const FastListItemLayout({
    super.key,
    required this.labelText,
    this.capitalizeLabelText = true,
    this.minLeadingWidth = 16.0,
    this.isEnabled = true,
    this.isDense = true,
    this.selectionLabelColor,
    this.descriptionText,
    this.contentPadding,
    this.selectionColor,
    this.descriptor,
    this.trailing,
    this.leading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeHelper.getListTitleTheme(
      context: context,
      child: Container(
        color: selectionColor,
        child: ListTile(
          trailing: descriptor?.trailing ?? trailing,
          leading: descriptor?.leading ?? leading,
          dense: descriptor?.isDense ?? isDense,
          minLeadingWidth: minLeadingWidth,
          subtitle: buildItemDescription(),
          contentPadding: contentPadding,
          title: buildItemLabel(),
          enabled: isEnabled,
          onTap: onTap,
        ),
      ),
    );
  }

  /// Builds the item label.
  Widget buildItemLabel() {
    final text =
        capitalizeLabelText ? toBeginningOfSentenceCase(labelText)! : labelText;

    return FastBody(textColor: selectionLabelColor, text: text);
  }

  /// Builds the item description.
  Widget? buildItemDescription() {
    Widget? description;

    if (descriptionText != null) {
      description = FastSecondaryBody(text: descriptionText!);
    }

    return description;
  }
}
