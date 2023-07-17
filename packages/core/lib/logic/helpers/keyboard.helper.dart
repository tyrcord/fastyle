import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

void hideKeyboard() {
  if (isWeb) return;

  if (isIOS || isAndroid) {
    FocusManager.instance.primaryFocus?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
