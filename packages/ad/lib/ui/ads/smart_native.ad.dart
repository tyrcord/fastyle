// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:t_helpers/helpers.dart';
import 'package:tbloc/tbloc.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

// TODO: support more native ad heights
class FastSmartNativeAd extends StatefulWidget {
  final WidgetBuilder? fallbackBuilder;
  final Duration? refreshInterval;
  final Widget? loadingWidget;
  final String? debugLabel;
  final FastAdInfo? adInfo;
  final FastAdSize adSize;
  final String? country;
  final String? language;
  final FastAdSlotDelegate? delegate;
  final Widget? placeholder;
  final String? adId;
  final bool showRemoveAdLink;
  final VoidCallback? onRemoveAdLinkTap;

  const FastSmartNativeAd({
    super.key,
    this.adSize = FastAdSize.medium,
    this.fallbackBuilder,
    this.debugLabel,
    this.country,
    this.adInfo,
    this.loadingWidget,
    this.language,
    this.placeholder,
    this.delegate,
    this.adId,
    this.refreshInterval,
    this.onRemoveAdLinkTap,
    this.showRemoveAdLink = false,
  }) : assert(
          adSize == FastAdSize.medium,
          'Only support native ad with a height of 120px',
        );

  @override
  FastSmartNativeAdState createState() => FastSmartNativeAdState();
}

class FastSmartNativeAdState extends State<FastSmartNativeAd> {
  final _featuresBloc = FastAppFeaturesBloc();
  final _nativeAdBloc = FastNativeAdBloc();
  final _key = UniqueKey();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();

    final payload = _getInitBlocEventPayload();
    _nativeAdBloc.addEvent(FastNativeAdBlocEvent.init(payload));
    _loadAd(payload);
    _startRefreshingAd();
  }

  @override
  void dispose() {
    super.dispose();

    _nativeAdBloc.close();
    _stopRefreshingAd();
  }

  Future<void> handleVisibilityChanged(VisibilityInfo info) async {
    if (mounted) {
      if (info.visibleFraction == 1) {
        _startRefreshingAd();
      } else {
        _stopRefreshingAd();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: handleVisibilityChanged,
      child: BlocBuilderWidget(
          buildWhen: (_, next) =>
              next.isFeatureEnabled(FastAppFeatures.premium),
          bloc: _featuresBloc,
          builder: (context, state) {
            final canShowAd = widget.delegate?.willShowAd() ?? !isUserPremium();

            if (!canShowAd) {
              return widget.placeholder ?? const SizedBox.shrink();
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FastNativeAdBuilder(
                  bloc: _nativeAdBloc,
                  builder: (BuildContext context, FastNativeAdBlocState state) {
                    if (state.adView != null) {
                      return buildAdmobNativeAd(
                        state.adView as NativeAd,
                        widget.adSize,
                      );
                    } else if (state.ad != null) {
                      return FastNativeAd(ad: state.ad!, adSize: widget.adSize);
                    } else if (state.showFallback) {
                      return buildFallback(context);
                    }

                    return widget.loadingWidget ??
                        getNativeAdLoadingWidget(widget.adSize);
                  },
                ),
                ...appendAdLink(),
              ],
            );
          }),
    );
  }

  List<Widget> appendAdLink() {
    if (!widget.showRemoveAdLink) {
      return [];
    }

    return [
      kFastVerticalSizedBox12,
      FastGoodbyeAdLink(onTap: widget.onRemoveAdLinkTap),
    ];
  }

  Widget buildFallback(BuildContext context) {
    if (widget.fallbackBuilder != null) {
      return widget.fallbackBuilder!(context);
    }

    return buildDefaultNativeAd();
  }

  Widget buildDefaultNativeAd() {
    return FastDefaultNativeAd(adSize: widget.adSize);
  }

  Widget buildAdmobNativeAd(NativeAd adView, FastAdSize adSize) {
    return FastNativeAdContainerLayout(
      adSize: adSize,
      child: AdWidget(ad: adView),
    );
  }

  Future<void> _loadAd(FastNativeAdBlocEventPayload payload) async {
    if (mounted) {
      await _nativeAdBloc.onData.where((state) => state.isInitialized).first;
      debugLog(
        'FastNativeAdBloc is loading an ad...',
        debugLabel: widget.debugLabel,
      );

      _nativeAdBloc.addEvent(FastNativeAdBlocEvent.loadAd(payload));
    }
  }

  FastAdInfo _getAdInfo() {
    if (widget.adInfo != null) {
      return widget.adInfo!;
    }

    final adInfoBloc = FastAdInfoBloc();

    return adInfoBloc.currentState.adInfo;
  }

  Duration _getAdRefreshInterval() {
    if (widget.refreshInterval != null) {
      return widget.refreshInterval!;
    }

    final adInfo = _getAdInfo();
    final refreshInterval = adInfo.refreshInterval;

    return Duration(seconds: refreshInterval);
  }

  (String, String?) _getUserInfo() {
    final appInfoBloc = FastAppInfoBloc();
    final appSettingsBloc = FastAppSettingsBloc();
    final appInfo = appInfoBloc.currentState;
    final appSettings = appSettingsBloc.currentState;
    final country = widget.country ?? appInfo.deviceCountryCode;
    final language = widget.language ?? appSettings.languageCode;

    return (language, country);
  }

  FastNativeAdBlocEventPayload _getInitBlocEventPayload() {
    final (language, country) = _getUserInfo();

    return FastNativeAdBlocEventPayload(
      adInfo: _getAdInfo(),
      language: language,
      adId: widget.adId,
      country: country,
    );
  }

  void _startRefreshingAd() {
    debugLog('start refreshing ad', debugLabel: widget.debugLabel);
    _refreshTimer?.cancel();
    final refreshInterval = _getAdRefreshInterval();

    _refreshTimer = Timer.periodic(refreshInterval, (Timer timer) {
      final payload = _getInitBlocEventPayload();
      _loadAd(payload);
    });
  }

  void _stopRefreshingAd() {
    debugLog('stop refreshing ad', debugLabel: widget.debugLabel);
    _refreshTimer?.cancel();
  }
}
