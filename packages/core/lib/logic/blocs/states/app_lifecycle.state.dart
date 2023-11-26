// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

/// Represents the state of the application's lifecycle.
///
/// It holds the [AppLifecycleState] which tracks the lifecycle events
/// (i.e., detached, inactive, paused, and resumed) to react to changes.
class FastAppLifecycleBlocState extends BlocState {
  final AppLifecycleState appLifeCycleState;

  FastAppLifecycleBlocState({
    this.appLifeCycleState = AppLifecycleState.detached,
  });

  @override
  FastAppLifecycleBlocState clone() => copyWith();

  /// Creates a copy of this state but with the given fields replaced with
  /// the new values.
  @override
  FastAppLifecycleBlocState copyWith({AppLifecycleState? appLifeCycleState}) {
    return FastAppLifecycleBlocState(
        appLifeCycleState: appLifeCycleState ?? this.appLifeCycleState);
  }

  /// Combines the current state with the new model.
  ///
  /// It will replace the existing [appLifeCycleState] with the [model]'s
  /// corresponding value.
  @override
  FastAppLifecycleBlocState merge(covariant FastAppLifecycleBlocState model) {
    return copyWith(appLifeCycleState: model.appLifeCycleState);
  }

  @override
  List<Object?> get props => [appLifeCycleState];
}
