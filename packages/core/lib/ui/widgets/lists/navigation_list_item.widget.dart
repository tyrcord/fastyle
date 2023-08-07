// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationListItem<T extends FastItem> extends StatelessWidget {
  final EdgeInsets? contentPadding;

  ///
  /// Allow to convert the label to beginning of sentence case.
  ///
  final bool capitalizeLabelText;
  final String? descriptionText;
  final VoidCallback onTap;
  final String? labelText;
  final Widget? leading;
  final Widget? trailing;
  final bool isEnabled;
  final bool isDense;
  final T? item;
  final bool showTrailing;
  final bool showLeading;

  const FastNavigationListItem({
    super.key,
    required this.onTap,
    this.trailing,
    this.capitalizeLabelText = true,
    this.isEnabled = true,
    this.isDense = true,
    this.showTrailing = true,
    this.showLeading = true,
    this.descriptionText,
    this.contentPadding,
    this.labelText,
    this.leading,
    this.item,
  }) : assert(item != null || labelText != null);

  @override
  Widget build(BuildContext context) {
    return FastListItemLayout(
      leading: showLeading ? item?.descriptor?.leading ?? leading : null,
      trailing: showTrailing ? buildTrailingIcon(context) : null,
      descriptionText: item?.descriptionText ?? descriptionText,
      isDense: item?.descriptor?.isDense ?? isDense,
      labelText: item?.labelText ?? labelText!,
      capitalizeLabelText: capitalizeLabelText,
      isEnabled: item?.isEnabled ?? isEnabled,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }

  Widget buildTrailingIcon(BuildContext context) {
    if (item?.descriptor?.trailing != null) {
      return item!.descriptor!.trailing!;
    }

    if (trailing != null) {
      return trailing!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightChevronRight);
    }

    return const FaIcon(FontAwesomeIcons.chevronRight);
  }
}
