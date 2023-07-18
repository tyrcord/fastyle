// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastSwitchFieldMenuButton<T> extends StatelessWidget {
  final List<PopupMenuItem<T>> options;
  final Function(T) onOptionChanged;

  const FastSwitchFieldMenuButton({
    Key? key,
    required this.options,
    required this.onOptionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastPopupMenuButton<T>(
      itemBuilder: (BuildContext context) => options,
      iconAlignment: Alignment.centerRight,
      onSelected: onOptionChanged,
      padding: EdgeInsets.zero,
      icon: Icon(
        FontAwesomeIcons.ellipsisVertical,
        color: ThemeHelper.texts.getBodyTextStyle(context).color,
        size: kFastIconSizeSmall,
      ),
    );
  }
}
