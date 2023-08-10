// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_ad/fastyle_ad.dart';
import 'package:fastyle_core/fastyle_core.dart';

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
    _cancelAdRequest();
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
                content = const FastTitle(text: 'No ad to show');
              } else if (state.isLoadingAd) {
                content = const FastThreeBounceIndicator();
              } else if (state.isRewarded) {
                content = const FastTitle(text: 'Ad rewarded');
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
              FastOutlineButton(text: 'reset', onTap: _cancelAdRequest),
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
            text: 'Show controlled operation',
            onTap: () => showOperationControlledDialog(
              onGetTitleText: (status) {
                if (status == FastOperationStatus.initial) {
                  return 'Operation';
                } else if (status == FastOperationStatus.missingRights) {
                  return 'Free Plan';
                } else if (status == FastOperationStatus.operationSucceeded) {
                  return 'Succeeded';
                } else if (status == FastOperationStatus.operationFailed) {
                  return 'Failed';
                } else if (status == FastOperationStatus.rightsDenied) {
                  return 'Oops!';
                } else if (status == FastOperationStatus.error) {
                  return 'Error';
                }

                return 'Loading...';
              },
              onGetValidText: (status) {
                if (status == FastOperationStatus.initial) {
                  return 'Perform';
                } else if (status == FastOperationStatus.missingRights) {
                  return 'Watch an Ad';
                } else if (status == FastOperationStatus.operationSucceeded ||
                    status == FastOperationStatus.operationFailed ||
                    status == FastOperationStatus.rightsDenied ||
                    status == FastOperationStatus.error) {
                  return 'Done';
                }

                return null;
              },
              context: context,
              intialBuilder: (context) {
                return const FastBody(
                  text: 'Do you want to obtain a reward?',
                  textAlign: TextAlign.center,
                );
              },
              onCreateOperation: ({value}) async {
                await Future.delayed(const Duration(seconds: 3));

                // await Future.error('An error occured');

                return true;
              },
              onVerifyRights: () async {
                final hasRights = await Future.delayed(
                    const Duration(seconds: 1), () => false);

                // await Future.error('An error occured');

                return hasRights;
              },
              onGrantRights: () async {
                final hasRights = await Future.delayed(
                  const Duration(seconds: 3),
                  () => true,
                );

                // await Future.error('An error occured');

                return hasRights;
              },
            ),
          )
        ],
      ),
    );
  }

  void _cancelAdRequest() {
    rewardedAdBloc.addEvent(const FastRewardedAdBlocEvent.cancelAdRequest());
  }
}
