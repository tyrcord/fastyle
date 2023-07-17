import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

class FastAppDictJob extends FastJob {
  static FastAppDictJob? _singleton;

  factory FastAppDictJob() {
    return (_singleton ??= FastAppDictJob._());
  }

  FastAppDictJob._() : super(debugLabel: 'fast_app_dict_job');

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
  }
}
