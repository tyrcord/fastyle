// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

mixin FastButtonSyleMixin<T extends FastButton> on State<T> {
  WidgetStateProperty<OutlinedBorder> getButtonShape() {
    return WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }

  WidgetStateProperty<EdgeInsetsGeometry?> getButtonPadding() {
    return WidgetStateProperty.all<EdgeInsetsGeometry?>(widget.padding);
  }

  WidgetStateProperty<Color> getOverlayColor(Color textColor) {
    return WidgetStateProperty.all<Color>(
      widget.highlightColor ?? textColor.withOpacity(0.1),
    );
  }

  FastButtonLabel buildButtonLabel(
    Color textColor, {
    Color? disabledTextColor,
    bool upperCase = true,
    double? fontSize,
  }) {
    return FastButtonLabel(
      text: widget.text ?? CoreLocaleKeys.core_label_button.tr(),
      textColor: widget.isEnabled
          ? textColor
          : disabledTextColor ?? textColor.withAlpha(kDisabledAlpha),
      upperCase: upperCase,
      fontSize: fontSize,
    );
  }
}
