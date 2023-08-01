// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastToggleListItem<T extends FastItem> extends StatefulWidget {
  final ValueChanged<bool> onValueChanged;
  final String? descriptionText;
  final String? labelText;
  final Widget? leading;
  final bool isEnabled;
  final bool isChecked;
  final bool isDense;
  final T? item;

  FastToggleListItem({
    super.key,
    required this.onValueChanged,
    this.isChecked = false,
    this.isEnabled = true,
    this.isDense = true,
    this.descriptionText,
    this.labelText,
    this.leading,
    this.item,
  })  : assert(item?.labelText != null || labelText != null);

  @override
  State<StatefulWidget> createState() => _FastToggleListItemState();
}

class _FastToggleListItemState extends State<FastToggleListItem> {
  late bool _value;

  @override
  void didUpdateWidget(covariant FastToggleListItem<FastItem> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isChecked != widget.isChecked) {
      setState(() => _value = widget.isChecked);
    }
  }

  @override
  void initState() {
    _value = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeHelper.getListTitleTheme(
      context: context,
      child: SwitchListTile.adaptive(
        activeColor: ThemeHelper.colors.getPrimaryColor(context),
        inactiveTrackColor: ThemeHelper.colors.getHintColor(context),
        dense: widget.isDense,
        title: _buildLabel(),
        subtitle: _buildDescription(),
        onChanged: _onChanged,
        secondary: widget.item?.descriptor?.leading ?? widget.leading,
        value: _value,
      ),
    );
  }

  Widget _buildLabel() {
    return FastBody(text: (widget.item?.labelText ?? widget.labelText)!);
  }

  Widget? _buildDescription() {
    final item = widget.item;
    final descriptionText = item?.descriptionText ?? widget.descriptionText;

    return descriptionText != null
        ? FastSecondaryBody(text: descriptionText)
        : null;
  }

  void _onChanged(bool value) {
    if (widget.item?.isEnabled ?? widget.isEnabled) {
      setState(() {
        _value = value;
        widget.onValueChanged(value);
      });
    }
  }
}
