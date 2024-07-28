// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';

mixin FastThrottleButtonMixin2<T extends FastButton2> on State<T> {
  @protected
  final trottler = PublishSubject<Function>();

  @protected
  // ignore: cancel_subscriptions
  StreamSubscription<Function>? subscriptionStream;

  @protected
  VoidCallback? onTapCallback;

  bool _isThrottled = false;

  @override
  void initState() {
    super.initState();
    _updateThrottleState();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.trottleTimeDuration != widget.trottleTimeDuration ||
        oldWidget.shouldTrottleTime != widget.shouldTrottleTime ||
        oldWidget.isEnabled != widget.isEnabled ||
        oldWidget.onTap != widget.onTap) {
      _updateThrottleState();
    }
  }

  @override
  void dispose() {
    unsubscribeToTrottlerEventsIfNeeded();
    trottler.close();
    super.dispose();
  }

  void _updateThrottleState() {
    if (widget.isEnabled && widget.shouldTrottleTime) {
      if (!_isThrottled) {
        subscribeToTrottlerEvents();
        _isThrottled = true;
      }
    } else {
      unsubscribeToTrottlerEventsIfNeeded();
      _isThrottled = false;
    }

    onTapCallback = _getOnTapCallBack();
  }

  @protected
  VoidCallback? _getOnTapCallBack() {
    if (widget.isEnabled) {
      if (_isThrottled) return () => trottler.add(widget.onTap!);

      return widget.onTap;
    }

    return null;
  }

  @protected
  void subscribeToTrottlerEvents() {
    unsubscribeToTrottlerEventsIfNeeded();

    subscriptionStream = trottler
        .throttleTime(widget.trottleTimeDuration)
        .listen((Function onTap) => onTap());
  }

  @protected
  void unsubscribeToTrottlerEventsIfNeeded() {
    subscriptionStream?.cancel();
    subscriptionStream = null;
  }
}
