// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

mixin FastDebounceInputMixin<T extends IFastInput> on State<T> {
  @protected
  final debouncer = PublishSubject<Function>();

  @protected
  // ignore: cancel_subscriptions
  StreamSubscription<Function>? subscriptionStream;

  @protected
  ValueChanged<String>? debounceOnValueChangedIfNeeded() {
    if (widget.isEnabled && widget.onValueChanged != null) {
      if (widget.shouldDebounceTime) {
        subscribeToDebouncerEvents();

        return (String value) {
          return debouncer.add(() => widget.onValueChanged!(value));
        };
      }

      unsubscribeToDebouncerEventsIfNeeded();

      return widget.onValueChanged;
    }

    unsubscribeToDebouncerEventsIfNeeded();

    return null;
  }

  @protected
  void subscribeToDebouncerEvents() {
    unsubscribeToDebouncerEventsIfNeeded();

    if (widget.isEnabled && widget.shouldDebounceTime) {
      subscriptionStream = debouncer
          .debounceTime(widget.debounceTimeDuration)
          .listen((Function dispatchValueChanged) => dispatchValueChanged());
    }
  }

  @protected
  void unsubscribeToDebouncerEventsIfNeeded() {
    subscriptionStream?.cancel();
  }
}
