import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc/tbloc.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:t_helpers/helpers.dart';

class FastRewardedAdJob extends FastJob {
  static FastRewardedAdJob? _singleton;

  factory FastRewardedAdJob() {
    return (_singleton ??= FastRewardedAdJob._());
  }

  FastRewardedAdJob._() : super(debugLabel: 'fast_rewarded_ad_job');

  @override
  Future<void> initialize(
    BuildContext context, {
    IFastErrorReporter? errorReporter,
  }) async {
    if (isWeb) return;

    final adInfoBloc = BlocProvider.of<FastAdInfoBloc>(context);
    final rewardedAdBloc = BlocProvider.of<FastRewardedAdBloc>(context);
    final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
    final appInfo = appInfoBloc.currentState;
    final adInfo = adInfoBloc.currentState.adInfo;

    rewardedAdBloc.addEvent(FastRewardedAdBlocEvent.init(
      FastRewardedAdBlocEventPayload(
        country: appInfo.deviceCountryCode,
        adInfo: adInfo,
      ),
    ));

    await rewardedAdBloc.onData.firstWhere((state) => state.isInitialized);

    final response = await RaceStream([
      rewardedAdBloc.onError,
      rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
        return state.isInitialized;
      }),
    ]).first;

    if (response is! FastRewardedAdBlocState) {
      throw response;
    }
  }
}
