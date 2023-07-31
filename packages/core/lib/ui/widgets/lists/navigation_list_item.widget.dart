// Flutter imports:
import 'package:flutter/material.dart';

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
  final Widget trailing;
  final bool isEnabled;
  final bool isDense;
  final T? item;
  final bool showTrailing;
  final bool showLeading;

  const FastNavigationListItem({
    Key? key,
    required this.onTap,
    this.trailing = kFastNavigationTrailingIcon,
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
  })  : assert(item != null || labelText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastListItemLayout(
      trailing: showTrailing ? item?.descriptor?.trailing ?? trailing : null,
      leading: showLeading ? item?.descriptor?.leading ?? leading : null,
      descriptionText: item?.descriptionText ?? descriptionText,
      isDense: item?.descriptor?.isDense ?? isDense,
      labelText: item?.labelText ?? labelText!,
      capitalizeLabelText: capitalizeLabelText,
      isEnabled: item?.isEnabled ?? isEnabled,
      contentPadding: contentPadding,
      onTap: onTap,
    );
  }
}
