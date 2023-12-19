// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictJob extends FastJob {
  static FastAppDictJob? _singleton;

  final List<FastDictEntryEntity>? defaultEntries;

  factory FastAppDictJob({List<FastDictEntryEntity>? defaultEntries}) {
    return (_singleton ??= FastAppDictJob._(defaultEntries: defaultEntries));
  }

  const FastAppDictJob._({this.defaultEntries})
      : super(debugLabel: 'FastAppDictJob');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    final bloc = FastAppDictBloc.instance;
    bloc.addEvent(const FastAppDictBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((FastAppDictBlocState state) => state.isInitialized),
    ]).first;

    if (blocState is! FastAppDictBlocState) {
      throw blocState;
    }

    await _addDefaultEntries();
  }

  Future<void> _addDefaultEntries() async {
    final bloc = FastAppDictBloc.instance;
    final entries = defaultEntries ?? [];

    if (entries.isNotEmpty) {
      final oldEntries = bloc.currentState.entries;
      final oldEntriesIds = oldEntries.map((e) => e.name).toList();

      // Filter out entries that already exist in previousEntries
      final newEntries = entries.where((entry) {
        return !oldEntriesIds.contains(entry.name);
      }).toList();

      if (newEntries.isEmpty) return;

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
        throw blocState;
      }
    }
  }
}
