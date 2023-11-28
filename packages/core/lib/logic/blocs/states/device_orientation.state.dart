// Package imports:
import 'package:tbloc/tbloc.dart';

import 'package:flutter/material.dart';

class FastDeviceOrientationBlocState extends BlocState {
  final Orientation orientation;

  FastDeviceOrientationBlocState({
    this.orientation = Orientation.portrait,
    super.isInitialized = true,
  });

  @override
  FastDeviceOrientationBlocState clone() => copyWith();

  @override
  FastDeviceOrientationBlocState copyWith({
    Orientation? orientation,
    bool? isLoading,
    bool? isLoaded,
  }) {
    return FastDeviceOrientationBlocState(
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  FastDeviceOrientationBlocState merge(
      covariant FastDeviceOrientationBlocState model) {
    return copyWith(
      orientation: model.orientation,
    );
  }

  @override
  List<Object?> get props => [orientation];
}
