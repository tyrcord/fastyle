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
import 'package:subx/subx.dart';

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
  final VoidCallback? onRemoveAdLinkTap;
  final bool? showRemoveAdLink;
  final bool? autoRefresh;

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
    this.onRemoveAdLinkTap,
    this.refreshInterval,
    this.showRemoveAdLink,
    this.autoRefresh,
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
  VisibilityInfo? _visibilityInfo;
  Timer? _refreshTimer;

  @protected
  final _subxList = SubxList();

  bool get isVisible {
    return _visibilityInfo?.visibleFraction == 1;
  }

  String get debugLabel {
    return widget.debugLabel ?? 'FastSmartNativeAd';
  }

  bool get isAutoRefreshEnabled {
    final adInfo = _getAdInfo();

    return widget.autoRefresh ?? adInfo.autoRefresh;
  }

  bool get canShowRemoveAdLink {
    final adInfo = _getAdInfo();

    return widget.showRemoveAdLink ?? adInfo.showRemoveAdLink;
  }

  @override
  void initState() {
    super.initState();

    _subxList.add(listenToAppLifecycleChanges());
    final payload = _getInitBlocEventPayload();
    _nativeAdBloc.addEvent(FastNativeAdBlocEvent.init(payload));
    _loadAd(payload);
  }

  @override
  void dispose() {
    super.dispose();

    _subxList.cancelAll();
    _nativeAdBloc.close();
  }

  Future<void> handleVisibilityChanged(VisibilityInfo visibilityInfo) async {
    _visibilityInfo = visibilityInfo;
    isVisible ? _startRefreshingAd() : _stopRefreshingAd();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: handleVisibilityChanged,
      child: BlocBuilderWidget(
        buildWhen: (_, next) {
          return next.isFeatureEnabled(FastAppFeatures.adFree);
        },
        bloc: _featuresBloc,
        builder: (context, state) {
          final canShowAd = widget.delegate?.willShowAd() ?? !isAdFreeEnabled();

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
                    debugLog('Show an ad from Admob', debugLabel: debugLabel);

                    return buildAdmobNativeAd(
                      state.adView as NativeAd,
                      widget.adSize,
                    );
                  } else if (state.ad != null) {
                    debugLog('show an ad from Lumen', debugLabel: debugLabel);

                    return FastNativeAd(ad: state.ad!, adSize: widget.adSize);
                  } else if (state.showFallback) {
                    debugLog('Show a fallback ad', debugLabel: debugLabel);

                    return buildFallback(context);
                  }

                  return widget.loadingWidget ??
                      getNativeAdLoadingWidget(widget.adSize);
                },
              ),
              ...?appendAdLink(),
            ],
          );
        },
      ),
    );
  }

  List<Widget>? appendAdLink() {
    if (canShowRemoveAdLink) {
      return [
        kFastVerticalSizedBox16,
        // Using Align in order to avoid stretching the ad link.
        Align(
          alignment: Alignment.bottomLeft,
          child: FastGoodbyeAdLink(onTap: widget.onRemoveAdLinkTap),
        ),
      ];
    }

    return null;
  }

  Widget buildFallback(BuildContext context) {
    if (widget.fallbackBuilder != null) widget.fallbackBuilder!(context);

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
      debugLog('Requesting an ad...', debugLabel: debugLabel);

      await _nativeAdBloc.onData.where((state) => state.isInitialized).first;

      if (mounted) {
        _nativeAdBloc.addEvent(FastNativeAdBlocEvent.loadAd(payload));
      }
    }
  }

  FastAdInfo _getAdInfo() {
    if (widget.adInfo != null) widget.adInfo!;

    final adInfoBloc = FastAdInfoBloc.instance;

    return adInfoBloc.currentState.adInfo;
  }

  Duration _getAdRefreshInterval() {
    if (widget.refreshInterval != null) return widget.refreshInterval!;

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
    if (!isAutoRefreshEnabled) return _stopRefreshingAd();

    final appLifecycleBloc = FastAppLifecycleBloc.instance;
    final appLifecycleState = appLifecycleBloc.currentState.appLifeCycleState;
    _stopRefreshingAd();

    if (appLifecycleState == AppLifecycleState.paused) return;

    debugLog('start refreshing ad', debugLabel: debugLabel);
    final refreshInterval = _getAdRefreshInterval();

    _refreshTimer = Timer.periodic(refreshInterval, (Timer timer) {
      debugLog('Timer is up => load a new ad', debugLabel: debugLabel);
      final payload = _getInitBlocEventPayload();
      _loadAd(payload);
    });
  }

  void _stopRefreshingAd() {
    if (_refreshTimer != null) {
      debugLog('stop refreshing ad', debugLabel: debugLabel);
      _refreshTimer!.cancel();
      _refreshTimer = null;
    }
  }

  @protected
  StreamSubscription<FastAppLifecycleBlocState> listenToAppLifecycleChanges() {
    final appLifecycleBloc = FastAppLifecycleBloc.instance;

    return appLifecycleBloc.onData.listen((state) {
      if (!isVisible) return;

      if (state.appLifeCycleState == AppLifecycleState.paused) {
        debugLog('App paused => stop refreshing ad', debugLabel: debugLabel);
        _stopRefreshingAd();
      } else if (_refreshTimer == null) {
        debugLog('App resumed => start refreshing ad', debugLabel: debugLabel);
        _startRefreshingAd();
      }
    });
  }
}
