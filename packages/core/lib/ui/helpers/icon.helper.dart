// Flutter imports
import 'package:flutter/material.dart';

/// An [InheritedWidget] to determine whether to use Pro icons.
/// Provides a mechanism to access `useProIcons` property from its descendants.
class FastIconHelper extends InheritedWidget {
  final bool useProIcons;

  // Constructor
  const FastIconHelper({
    super.key,
    required this.useProIcons,
    required super.child,
  });

  /// Attempts to retrieve the [FastIconHelper] from the provided context.
  /// Returns null if not found.
  static FastIconHelper? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FastIconHelper>();
  }

  /// Retrieves the [ProIconPreference] from the provided context.
  /// Throws an error if not found.
  static FastIconHelper of(BuildContext context) {
    final FastIconHelper? result = maybeOf(context);
    assert(result != null, 'No FastIconHelper found in context');

    return result!;
  }

  @override
  bool updateShouldNotify(FastIconHelper oldWidget) {
    return useProIcons != oldWidget.useProIcons;
  }
}
