// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictJob extends FastJob {
  static final TLogger _logger = _manager.getLogger(_debugLabel);
  static const _debugLabel = 'FastAppDictJob';
  static final _manager = TLoggerManager();
  static FastAppDictJob? _singleton;

  final List<FastDictEntryEntity>? defaultEntries;

  factory FastAppDictJob({List<FastDictEntryEntity>? defaultEntries}) {
    return (_singleton ??= FastAppDictJob._(defaultEntries: defaultEntries));
  }

  const FastAppDictJob._({this.defaultEntries})
      : super(debugLabel: _debugLabel);

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    _logger.debug('Initializing...');

    final bloc = FastAppDictBloc.instance;
    bloc.addEvent(const FastAppDictBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((state) => state.isInitialized),
    ]).first;

    if (blocState is! FastAppDictBlocState) {
      _logger.error('Failed to initialize: $blocState');
      throw blocState;
    }

    await _addDefaultEntries();

    for (final entry in FastAppDictBloc.instance.currentState.entries) {
      _logger.info('App Dict Entry: ${entry.name}', entry.value);
    }

    _logger.debug('Initialized');
  }

  Future<void> _addDefaultEntries() async {
    _logger.debug('Adding default entries...');

    final bloc = FastAppDictBloc.instance;
    final entries = defaultEntries ?? [];

    if (entries.isNotEmpty) {
      final oldEntries = bloc.currentState.entries;
      final oldEntriesIds = oldEntries.map((e) => e.name).toList();

      _logger
        ..debug('Old entries: $oldEntriesIds')
        ..debug('New entries: ${entries.map((e) => e.name).toList()}');

      // Filter out entries that already exist in previousEntries
      final newEntries = entries.where((entry) {
        return !oldEntriesIds.contains(entry.name);
      }).toList();

      if (newEntries.isEmpty) {
        _logger.debug('No new entries to add');
        return;
      } else {
        _logger.debug('New entries to add: ${newEntries.map((e) => e.name)}');
      }

      _logger.debug('Adding new entries...');

      bloc.addEvent(FastAppDictBlocEvent.patchEntries(newEntries));

      final blocState = await RaceStream([
        bloc.onError,
        bloc.onData.where((FastAppDictBlocState state) {
          for (final entry in newEntries) {
            if (!state.entries.contains(entry)) return false;
          }

          return true;
        }),
      ]).first;

      if (blocState is! FastAppDictBlocState) {
        _logger.error('Failed to add default entries: $blocState');
        throw blocState;
      }

      _logger.debug('Default entries added');
    }
  }
}
