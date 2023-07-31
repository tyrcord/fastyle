// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastFieldLayout extends StatelessWidget {
  ///
  /// Force to keep the helper boundaries even if there is no helper.
  ///
  final bool showHelperBoundaries;

  ///
  /// Allow to convert the label to beginning of sentence case.
  ///
  final bool capitalizeLabelText;

  ///
  /// Color for the helper.
  ///
  final Color? helperTextColor;

  ///
  /// Short text for additional information.
  ///
  final String? captionText;

  ///
  /// Text used to provide additional hints for the user in conjuction with
  /// input elements.
  ///
  final String? helperText;

  ///
  /// An icon that appears after the editable part of the text field.
  ///
  final Widget? suffixIcon;

  ///
  /// Empty space to surround the control.
  ///
  final EdgeInsets margin;

  ///
  /// Text that describes a field label.
  ///
  final String? labelText;

  ///
  /// The control contained by the FastButtonLayout.
  ///
  final Widget control;

  const FastFieldLayout({
    super.key,
    required this.control,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.showHelperBoundaries = true,
    this.capitalizeLabelText = true,
    this.helperTextColor,
    this.captionText,
    this.helperText,
    this.suffixIcon,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (labelText != null || captionText != null) _buildLabel(context),
          Stack(
            children: <Widget>[
              _buildControl(),
              if (suffixIcon != null) _buildSuffixIcon(),
            ],
          ),
          if (showHelperBoundaries) _buildHelper(context),
        ],
      ),
    );
  }

  Widget _buildControl() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 33.0),
      child: control,
    );
  }

  Widget _buildSuffixIcon() {
    return Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      width: kFastIconSizeXl,
      child: Align(
        alignment: Alignment.centerRight,
        child: suffixIcon,
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: FastSecondaryBody(
              text: (capitalizeLabelText
                      ? toBeginningOfSentenceCase(labelText)
                      : labelText) ??
                  kFastEmptyString,
              textColor: ThemeHelper.texts.getBodyTextStyle(context).color,
            ),
          ),
        ),
        if (captionText != null)
          FastCaption(text: toBeginningOfSentenceCase(captionText)!),
      ],
    );
  }

  Widget _buildHelper(BuildContext context) {
    final hasHelper = helperText != null;

    return Opacity(
      opacity: hasHelper ? 1.0 : 0.0,
      child: Container(
        margin: const EdgeInsets.only(top: 4.0),
        child: FastOverline(
          textColor: helperTextColor,
          text: hasHelper
              ? toBeginningOfSentenceCase(helperText)!
              : kFastEmptyString,
        ),
      ),
    );
  }
}
