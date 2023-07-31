// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationDestination {
  final Widget? selectedIcon;
  final String? tooltip;
  final String label;
  final String path;
  final Widget icon;
  final Key? key;

  const FastNavigationDestination({
    required this.label,
    required this.icon,
    required this.path,
    this.selectedIcon,
    this.tooltip,
    this.key,
  });

  NavigationDestination toNavigationDestination() {
    return NavigationDestination(
      selectedIcon: selectedIcon,
      tooltip: tooltip,
      label: label,
      icon: icon,
      key: key,
    );
  }

  NavigationRailDestination toNavigationRailDestination() {
    return NavigationRailDestination(
      label: Text(label),
      selectedIcon: selectedIcon,
      padding: kFastEdgeInsets12,
      icon: icon,
    );
  }
}
