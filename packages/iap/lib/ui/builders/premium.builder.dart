// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

/// Signature for a function that determines whether the widget should rebuild.
///
/// [context] is the current state and [state] is the next state.
typedef FastPlanBuilderCondition = bool Function(
  FastPlanBlocState context,
  FastPlanBlocState state,
);

/// A widget that rebuilds when changes occur in the [FastPlanBloc].
///
/// This widget acts as a bridge between the [FastPlanBloc] state and the
/// UI, triggering a rebuild when the state changes according to the specified
/// conditions.
class FastIapPlanBuilder extends StatelessWidget {
  /// The builder function to create a widget based on the [FastPlanBlocState].
  final BlocBuilder<FastPlanBlocState> builder;

  /// A callback that specifies when to rebuild the widget.
  ///
  /// If not provided, the widget rebuilds for any change in the bloc state.
  final FastPlanBuilderCondition? buildWhen;

  /// If set to true, rebuilds the widget only when the 'isRestoringPlan'
  /// state changes.
  final bool onlyWhenIsRestoringPlanChanges;

  /// If set to true, rebuilds the widget only when the 'isPlanPurcharsePending'
  /// state changes.
  final bool onlyWhenPurchaseChanges;

  /// Creates a [FastIapPlanBuilder] widget.
  ///
  /// [builder] must be provided.
  const FastIapPlanBuilder({
    super.key,
    required this.builder,
    this.buildWhen,
    this.onlyWhenIsRestoringPlanChanges = false,
    this.onlyWhenPurchaseChanges = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: BlocProvider.of<FastPlanBloc>(context),
      buildWhen: _shouldBuild,
      builder: builder,
    );
  }

  /// Determines whether the widget should rebuild based on the provided
  /// conditions.
  bool _shouldBuild(FastPlanBlocState previous, FastPlanBlocState next) {
    if (next.hasError) return true;

    if (buildWhen != null) {
      return buildWhen!.call(previous, next);
    }

    if (onlyWhenIsRestoringPlanChanges) {
      return previous.isRestoringPlan != next.isRestoringPlan;
    }

    if (onlyWhenPurchaseChanges) {
      return previous.isPlanPurchasePending != next.isPlanPurchasePending;
    }

    return true;
  }
}
