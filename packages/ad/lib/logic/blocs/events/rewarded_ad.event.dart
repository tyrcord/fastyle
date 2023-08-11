// Package imports:
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastRewardedAdBlocEvent extends BlocEvent<FastRewardedAdBlocEventType,
    FastRewardedAdBlocEventPayload> {
  const FastRewardedAdBlocEvent.init(
    FastRewardedAdBlocEventPayload payload,
  ) : super(type: FastRewardedAdBlocEventType.init, payload: payload);

  const FastRewardedAdBlocEvent.initialized()
      : super(type: FastRewardedAdBlocEventType.initalized);

  const FastRewardedAdBlocEvent.loadAndShowAd()
      : super(type: FastRewardedAdBlocEventType.loadAndShowAd);

  const FastRewardedAdBlocEvent.adLoaded()
      : super(type: FastRewardedAdBlocEventType.adLoaded);

  FastRewardedAdBlocEvent.adLoadingError(dynamic error)
      : super(
          type: FastRewardedAdBlocEventType.adLoadingError,
          payload: FastRewardedAdBlocEventPayload(error: error),
        );

  FastRewardedAdBlocEvent.adShowingError(dynamic error)
      : super(
          type: FastRewardedAdBlocEventType.adShowingError,
          payload: FastRewardedAdBlocEventPayload(error: error),
        );

  const FastRewardedAdBlocEvent.adShowed()
      : super(type: FastRewardedAdBlocEventType.adShowed);

  FastRewardedAdBlocEvent.earnedReward(RewardItem reward)
      : super(
          type: FastRewardedAdBlocEventType.earnedReward,
          payload: FastRewardedAdBlocEventPayload(reward: reward),
        );

  const FastRewardedAdBlocEvent.adDismissed()
      : super(type: FastRewardedAdBlocEventType.adDismissed);

  const FastRewardedAdBlocEvent.clearAndCancelAdRequest()
      : super(type: FastRewardedAdBlocEventType.clearAndCancelAdRequest);
}
