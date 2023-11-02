// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

/// `FastFadeTransitionPage` is a widget that extends the functionality of
/// a `CustomTransitionPage` to provide a fade transition effect.
/// This effect is driven by a linear curve to fade in and out quickly.
class FastFadeTransitionPage extends CustomTransitionPage<void> {
  // Constructor
  const FastFadeTransitionPage({
    super.key,
    required super.child,
  }) : super(transitionsBuilder: _fadeTransitionBuilder);

  // A CurveTween with a linear curve. This provides a linear transition effect.
  static final CurveTween _linearCurveTween = CurveTween(curve: Curves.linear);

  /// Builds the fade transition effect.
  ///
  /// Parameters:
  /// - [context]: The build context.
  /// - [animation]: The primary animation.
  /// - [secondaryAnimation]: The secondary animation (not used here).
  /// - [child]: The widget that should receive the transition.
  ///
  /// Returns:
  /// - A widget with a fade transition effect.
  static Widget _fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation.drive(_linearCurveTween),
      child: child,
    );
  }
}
