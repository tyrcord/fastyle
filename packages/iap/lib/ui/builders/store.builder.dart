// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

/// A callback used to determine if the [FastStorePlanBuilder] should rebuild.
typedef FastStorePlanBuilderCondition = bool Function(
  FastStoreBlocState context,
  FastStoreBlocState state,
);

/// A widget that builds itself based on the latest snapshot. This widget
/// will return a child widget that corresponds to the current state of the
/// [FastStoreBloc].
class FastStorePlanBuilder extends StatelessWidget {
  /// The function that will be called with the current build context and
  /// the current state and must return a widget.
  final BlocBuilder<FastStoreBlocState> builder;

  /// The function that will be called with the previous state and the current
  /// state and must return a boolean. If `buildWhen` is provided, the builder
  /// will only be called if the function returns true.
  final FastStorePlanBuilderCondition? buildWhen;

  /// Whether the builder should be called only when products change.
  final bool onlyWhenProductsChanges;

  /// Creates a new [FastStorePlanBuilder].
  ///
  /// The [builder] is a required argument and must not be null.
  /// Optionally, the [buildWhen] and [onlyWhenProductsChanges] can be provided.
  const FastStorePlanBuilder({
    super.key,
    required this.builder,
    this.onlyWhenProductsChanges = false,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastStoreBloc.instance,
      buildWhen: _shouldBuild,
      builder: builder,
    );
  }

  /// Determines if the builder should be called based on the previous and
  /// the next states.
  ///
  /// This function takes into account the provided [buildWhen] and
  /// [onlyWhenProductsChanges] parameters to make its decision.
  bool _shouldBuild(FastStoreBlocState previous, FastStoreBlocState next) {
    if (next.hasError) return true;

    if (buildWhen != null) {
      return buildWhen!.call(previous, next);
    }

    if (onlyWhenProductsChanges) {
      return previous.products != next.products;
    }

    return true;
  }
}
