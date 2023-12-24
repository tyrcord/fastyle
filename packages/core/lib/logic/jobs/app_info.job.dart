// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppInfoJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppInfoJob';
  static final _manager = TLoggerManager();
  static FastAppInfoJob? _singleton;

  final DatabaseVersionChanged? onDatabaseVersionChanged;
  final FastAppInfoDocument appInfoDocument;

  factory FastAppInfoJob(
    FastAppInfoDocument appInformationModel, {
    DatabaseVersionChanged? onDatabaseVersionChanged,
  }) {
    return (_singleton ??= FastAppInfoJob._(
      appInformationModel,
      onDatabaseVersionChanged: onDatabaseVersionChanged,
    ));
  }

  const FastAppInfoJob._(
    this.appInfoDocument, {
    this.onDatabaseVersionChanged,
  }) : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastAppInfoBloc.instance;
    bloc.addEvent(FastAppInfoBlocEvent.init(appInfoDocument));

    final appInfoState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (appInfoState is! FastAppInfoBlocState) {
      _logger.error('Failed to initialize: $appInfoState');
      throw appInfoState;
    }

    _logger.debug('Initialized');
  }
}
