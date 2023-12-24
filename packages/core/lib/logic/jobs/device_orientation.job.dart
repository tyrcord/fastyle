// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastDeviceOrientationJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastDeviceOrientationJob';
  static FastDeviceOrientationJob? _singleton;
  static final _manager = TLoggerManager();

  factory FastDeviceOrientationJob() {
    return (_singleton ??= const FastDeviceOrientationJob._());
  }

  const FastDeviceOrientationJob._() : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastDeviceOrientationBloc();
    final orientation = await findCurrentOrientation(context);

    bloc.addEvent(FastDeviceOrientationBlocEvent.changed(orientation));

    final blocState = await RaceStream([
      bloc.onData.where((state) => state.isInitialized),
      bloc.onError,
    ]).first;

    if (blocState is! FastDeviceOrientationBlocState) {
      _logger.error('Failed to initialize: $blocState');
      throw blocState;
    }

    _logger.debug('Initialized');
  }

  Future<Orientation> findCurrentOrientation(BuildContext context) async {
    final completer = Completer<Orientation>();

    try {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        final orientation = MediaQuery.orientationOf(context);
        _logger.info('current orientation', orientation);

        completer.complete(orientation);
      });
    } catch (e) {
      completer.complete(Orientation.portrait);
    }

    return completer.future;
  }
}
