// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

mixin FastAdInformationJobDelegate {
  FastAdInfo onGetAdInformationModel(BuildContext context);
}

class FastAdInfoJob extends FastJob {
  static FastAdInfoJob? _singleton;

  factory FastAdInfoJob({FastAdInformationJobDelegate? delegate}) {
    return (_singleton ??= FastAdInfoJob._(delegate: delegate));
  }

  final FastAdInformationJobDelegate? delegate;

  FastAdInfoJob._({this.delegate}) : super(debugLabel: 'fast_ad_info_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final adInfoBloc = BlocProvider.of<FastAdInfoBloc>(context);
    FastAdInfo appInfo = adInfoBloc.currentState.adInfo;

    if (delegate != null) {
      appInfo = delegate!.onGetAdInformationModel(context);
    }

    adInfoBloc.addEvent(FastAdInfoBlocEvent.init(adInfo: appInfo));

    await adInfoBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      adInfoBloc.onError,
      adInfoBloc.onData.where((FastAdInfoBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastAdInfoBlocState) {
      throw response;
    }
  }
}
