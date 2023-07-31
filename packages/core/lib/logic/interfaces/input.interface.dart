// Flutter imports:
import 'package:flutter/material.dart';

//TODO: @need-review: code from fastyle_dart

abstract class IFastInput extends StatefulWidget {
  final ValueChanged<String>? onValueChanged;
  final Duration debounceTimeDuration;
  final bool shouldDebounceTime;
  final bool isEnabled;

  const IFastInput({
    super.key,
    required this.debounceTimeDuration,
    this.shouldDebounceTime = false,
    this.isEnabled = true,
    this.onValueChanged,
  });
}
