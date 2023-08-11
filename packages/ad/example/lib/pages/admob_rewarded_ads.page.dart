// Flutter imports:
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_localization/easy_localization.dart';

class AdmobRewardedAdsPage extends StatefulWidget {
  const AdmobRewardedAdsPage({super.key});

  @override
  State<AdmobRewardedAdsPage> createState() => AdmobRewardedAdsPageState();
}

class AdmobRewardedAdsPageState extends State<AdmobRewardedAdsPage> {
  final rewardedAdBloc = FastRewardedAdBloc();
  final adBloc = FastAdInfoBloc();

  @override
  void dispose() {
    super.dispose();
    _clearAndCancelAdRequest();
  }

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Rewarded Ads',
      isViewScrollable: true,
      child: Column(
        children: [
          FastRewardedAdBuilder(
            builder: (context, state) {
              Widget? content;

              if (state.hasError) {
                content = const FastTitle(text: 'No ads to show');
              } else if (state.isLoadingAd) {
                content = const FastThreeBounceIndicator();
              } else if (state.hasDismissedAd) {
                content = const FastTitle(text: 'Ad dismissed');
              } else {
                content = const FastTitle(text: 'No ad loaded');
              }

              return SizedBox(
                height: 128,
                child: Center(child: content),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FastOutlineButton(text: 'reset', onTap: _clearAndCancelAdRequest),
              FastRewardedAdBuilder(builder: (context, state) {
                return FastRaisedButton(
                  text: 'Show rewarded ad',
                  isEnabled: !state.isLoadingAd,
                  onTap: () {
                    rewardedAdBloc.addEvent(
                      const FastRewardedAdBlocEvent.loadAndShowAd(),
                    );
                  },
                );
              }),
            ],
          ),
          kFastVerticalSizedBox48,
          FastRaisedButton(
            text: CoreLocaleKeys.core_label_export_pdf.tr(),
            onTap: () => showOperationControlledDialog(
              context: context,
              onGetTitleText: handleTitleChange,
              onGetValidText: handleValidTextChange,
              onCreateOperation: ({value}) async {
                await Future.delayed(const Duration(seconds: 3));

                // await Future.error('An error occured');

                return true;
              },
              onVerifyRights: () async {
                final hasRights = await Future.delayed(
                  const Duration(seconds: 1),
                  () => false,
                );

                // await Future.error('An error occured');

                return hasRights;
              },
              onGrantRights: () async {
                await _clearAndCancelAdRequest();

                rewardedAdBloc.addEvent(
                  const FastRewardedAdBlocEvent.loadAndShowAd(),
                );

                // Wait for the ad to be dismissed
                final response = await RaceStream([
                  rewardedAdBloc.onError,
                  rewardedAdBloc.onReward,
                  rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
                    return state.error != null;
                  }),
                  rewardedAdBloc.onData.where((FastRewardedAdBlocState state) {
                    return state.hasDismissedAd;
                  }),
                ]).first;

                if (response is RewardItem) {
                  return true;
                }

                if (response is FastRewardedAdBlocState) {
                  if (response.hasDismissedAd) {
                    return false;
                  }

                  if (response.error is FastRewardedAdBlocError) {
                    throw response.error as FastRewardedAdBlocError;
                  }
                }

                throw FastRewardedAdBlocError.unknown;
              },
              intialBuilder: (context) {
                return FastBody(
                  text: CoreLocaleKeys.core_question_export_data_pdf.tr(),
                );
              },
              missingRightsBuilder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FastBody(
                      text: PurchasesLocaleKeys
                          .purchases_message_have_not_acquired_premium_version
                          .tr(),
                    ),
                    kFastVerticalSizedBox16,
                    FastBody(
                      text: AdLocaleKeys.ad_message_watch_ad_unlock_pdf.tr(),
                    ),
                  ],
                );
              },
              errorBuilder: (context, error) {
                var message = CoreLocaleKeys.core_error_error_occurred.tr();

                if (error is FastRewardedAdBlocError) {
                  switch (error) {
                    case FastRewardedAdBlocError.noAdAvailable:
                      message = AdLocaleKeys.ad_error_no_ads_available.tr();
                    case FastRewardedAdBlocError.adFailedToLoad:
                      message = AdLocaleKeys.ad_error_failed_to_load_ad.tr();
                    case FastRewardedAdBlocError.unknown:
                      message = message;
                  }
                }

                return FastBody(text: message);
              },
              operationSucceededBuilder: (context) {
                final palette = ThemeHelper.getPaletteColors(context).green;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ThemeHelper.spacing.getVerticalSpacing(context),
                    FastValidIcon(
                      size: kFastIconSizeXl,
                      color: palette.mid,
                    ),
                    ThemeHelper.spacing.getVerticalSpacing(context),
                    FastBody(
                      text: AdLocaleKeys.ad_message_enjoy_your_reward.tr(),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String? handleTitleChange(status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_export_pdf.tr();
    } else if (status == FastOperationStatus.missingRights) {
      return PurchasesLocaleKeys.purchases_label_free_version.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_message_pdf_ready.tr();
    } else if (status == FastOperationStatus.operationFailed) {
      return CoreLocaleKeys.core_message_failed_to_generate_pdf.tr();
    } else if (status == FastOperationStatus.error ||
        status == FastOperationStatus.rightsDenied) {
      return CoreLocaleKeys.core_message_whoops.tr();
    } else if (status == FastOperationStatus.operationInProgress) {
      return CoreLocaleKeys.core_message_generating_pdf.tr();
    }

    return CoreLocaleKeys.core_message_please_wait.tr();
  }

  String? handleValidTextChange(status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_generate.tr();
    } else if (status == FastOperationStatus.missingRights) {
      return CoreLocaleKeys.core_label_watch_now.tr();
    } else if (status == FastOperationStatus.operationFailed ||
        status == FastOperationStatus.rightsDenied ||
        status == FastOperationStatus.error) {
      return CoreLocaleKeys.core_label_done.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_label_save_text.tr();
    }

    return null;
  }

  Future<void> _clearAndCancelAdRequest() async {
    rewardedAdBloc.addEvent(
      const FastRewardedAdBlocEvent.clearAndCancelAdRequest(),
    );

    await rewardedAdBloc.onData
        .where((state) => state.requestId == null && state.error == null)
        .first;
  }
}
