// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FastSettingsFab extends StatelessWidget {
  final VoidCallback onTap;
  final String? tooltip;
  final bool mini;

  /// Custom icon for the button (optional).
  final Widget? icon;

  const FastSettingsFab({
    super.key,
    required this.onTap,
    this.tooltip,
    this.mini = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: tooltip,
      onPressed: onTap,
      mini: mini,
      child: buildIcon(context),
    );
  }

  Widget buildIcon(BuildContext context) {
    if (icon != null) {
      return icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightGear);
    }

    return const FaIcon(FontAwesomeIcons.gear);
  }
}
