// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_ad/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_purchases/generated/locale_keys.g.dart';

class AdmobRewardedAdsPage extends StatefulWidget {
  const AdmobRewardedAdsPage({super.key});

  @override
  State<AdmobRewardedAdsPage> createState() => AdmobRewardedAdsPageState();
}

class AdmobRewardedAdsPageState extends State<AdmobRewardedAdsPage> {
  final rewardedAdBloc = FastRewardedAdBloc();
  final adBloc = FastAdInfoBloc.instance;

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
            onTap: () => showOperationRewardedDialog(
              missingRightsBuilder: buildMissingRights,
              onGetValidText: handleValidTextChange,
              onCreateOperation: onCreateOperation,
              onGetTitleText: handleTitleChange,
              onVerifyRights: onVerifyRights,
              intialBuilder: buildInitial,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInitial(BuildContext context) {
    return FastBody(
      text: CoreLocaleKeys.core_question_export_data_as_pdf.tr(),
    );
  }

  Widget buildMissingRights(context) {
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
  }

  Future<bool> onVerifyRights() async {
    final hasRights = await Future.delayed(
      const Duration(seconds: 1),
      () => false,
    );

    // await Future.error('An error occured');

    return hasRights;
  }

  Future<bool> onCreateOperation({value}) async {
    await Future.delayed(const Duration(seconds: 3));

    // await Future.error('An error occured');

    return true;
  }

  String? handleTitleChange(FastOperationStatus status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_export_pdf.tr();
    } else if (status == FastOperationStatus.missingRights) {
      return PurchasesLocaleKeys.purchases_label_free_version.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_message_pdf_ready.tr();
    } else if (status == FastOperationStatus.operationFailed) {
      return CoreLocaleKeys.core_message_failed_to_generate_pdf.tr();
    } else if (status == FastOperationStatus.operationInProgress) {
      return CoreLocaleKeys.core_message_generating_pdf.tr();
    }

    return FastOperationRewardedDialog.handleTitleChange(status);
  }

  String? handleValidTextChange(FastOperationStatus status) {
    if (status == FastOperationStatus.initial) {
      return CoreLocaleKeys.core_label_generate.tr();
    } else if (status == FastOperationStatus.operationSucceeded) {
      return CoreLocaleKeys.core_label_save_text.tr();
    }

    return FastOperationRewardedDialog.handleValidTextChange(status);
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
