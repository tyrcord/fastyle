// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:t_helpers/helpers.dart';

void hideKeyboard() {
  if (isWeb || isMacOS) return;

  if (isIOS || isAndroid) {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
