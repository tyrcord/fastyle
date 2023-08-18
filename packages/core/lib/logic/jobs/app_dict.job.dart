// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:tbloc/tbloc.dart';

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
    final bloc = BlocProvider.of<FastAppDictBloc>(context);
    bloc.addEvent(const FastAppDictBlocEvent.init());

    final blocState = await RaceStream([
      bloc.onError,
      bloc.onData.where((FastAppDictBlocState state) => state.isInitialized),
    ]).first;

    if (blocState is! FastAppDictBlocState) {
      throw blocState;
    }

    if (FastAppInfoBloc.instance.currentState.isFirstLaunch) {
      await _addDefaultEntries();
    }
  }

  Future<void> _addDefaultEntries() async {
    final bloc = FastAppDictBloc.instance;
    final entries = defaultEntries ?? [];

    if (entries.isNotEmpty) {
      bloc.addEvent(FastAppDictBlocEvent.patchEntries(entries));

      final blocState = await RaceStream([
        bloc.onError,
        bloc.onData.where((FastAppDictBlocState state) {
          for (final entry in entries) {
            if (!state.entries.contains(entry)) {
              return false;
            }
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
