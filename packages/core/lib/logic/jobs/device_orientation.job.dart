// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastDeviceOrientationJob extends FastJob {
  static FastDeviceOrientationJob? _singleton;

  factory FastDeviceOrientationJob() {
    return (_singleton ??= const FastDeviceOrientationJob._());
  }

  const FastDeviceOrientationJob._()
      : super(debugLabel: 'FastDeviceOrientationJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = FastDeviceOrientationBloc();
    final orientation = await findCurrentOrientation(context);

    bloc.addEvent(FastDeviceOrientationBlocEvent.changed(orientation));

    final blocState = await RaceStream([
      bloc.onData.where((state) => state.isInitialized),
      bloc.onError,
    ]).first;

    if (blocState is! FastDeviceOrientationBlocState) {
      throw blocState;
    }
  }

  Future<Orientation> findCurrentOrientation(BuildContext context) async {
    final completer = Completer<Orientation>();

    try {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        final orientation = MediaQuery.orientationOf(context);

        completer.complete(orientation);
      });
    } catch (e) {
      completer.complete(Orientation.portrait);
    }

    return completer.future;
  }
}
