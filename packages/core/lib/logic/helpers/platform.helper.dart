import 'package:flutter/material.dart';

Brightness getPlatformBrightness() {
  final platformDispatcher = WidgetsBinding.instance.platformDispatcher;
  final platformBrightness = platformDispatcher.platformBrightness;

  return platformBrightness;
}
