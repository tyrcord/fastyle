// Package imports:
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';

enum FastDeviceOrientationBlocEventType {
  changed,
}

class FastDeviceOrientationBlocEvent
    extends BlocEvent<FastDeviceOrientationBlocEventType, Orientation> {
  const FastDeviceOrientationBlocEvent({
    required FastDeviceOrientationBlocEventType type,
    Orientation? orientation,
  }) : super(type: type, payload: orientation);

  const FastDeviceOrientationBlocEvent.changed(Orientation orientation)
      : this(
          type: FastDeviceOrientationBlocEventType.changed,
          orientation: orientation,
        );
}
