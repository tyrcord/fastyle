// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:tlogger/logger.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

/// Checks whether the ad network can be reached before requesting ads.
///
/// When ad domains are blocked (Pi-hole, ad-blocking DNS, Private DNS) or the
/// device is offline, the Google Mobile Ads SDK does not fail fast: each
/// request waits for its timeout. A DNS lookup of the ad server answers in
/// milliseconds, so ad requests can be skipped right away instead.
class FastAdNetworkService {
  static const _debugLabel = 'FastAdNetworkService';
  static final _manager = TLoggerManager();

  /// The shared instance.
  static final instance = FastAdNetworkService._();

  late final TLogger _logger;

  Future<bool>? _pendingCheck;
  bool? _isReachable;
  DateTime? _checkedAt;

  FastAdNetworkService._() {
    _logger = _manager.getLogger(_debugLabel);
  }

  /// Whether the ad network can be reached.
  ///
  /// The result is cached for [kFastAdNetworkCheckTTL].
  Future<bool> isAdNetworkReachable() {
    final isReachable = _isReachable;
    final checkedAt = _checkedAt;

    if (isReachable != null &&
        checkedAt != null &&
        DateTime.now().difference(checkedAt) < kFastAdNetworkCheckTTL) {
      return Future.value(isReachable);
    }

    return _pendingCheck ??= _checkAdNetwork().whenComplete(() {
      _pendingCheck = null;
    });
  }

  Future<bool> _checkAdNetwork() async {
    var isReachable = false;

    try {
      final addresses = await InternetAddress.lookup(
        kFastAdNetworkCheckHost,
      ).timeout(kFastAdNetworkCheckTimeout);

      // DNS blockers answer with 0.0.0.0, :: or a loopback address.
      isReachable = addresses.any((address) {
        return !address.isLoopback &&
            !address.rawAddress.every((byte) => byte == 0);
      });
    } catch (error) {
      _logger.debug('Ad network lookup failed: $error');
    }

    if (!isReachable) {
      _logger.warning('Ad network is not reachable, skipping ad requests');
    }

    _isReachable = isReachable;
    _checkedAt = DateTime.now();

    return isReachable;
  }
}
