// Flutter imports:
import 'package:flutter/material.dart';

//TODO: @need-review: code from fastyle_dart

class FastOnboardingViewController extends ValueNotifier<bool> {
  FastOnboardingViewController({bool isPending = false}) : super(isPending);

  void resume() {
    if (value) {
      value = false;
      notifyListeners();
    }
  }

  void pause() {
    if (!value) {
      value = true;
      notifyListeners();
    }
  }
}
