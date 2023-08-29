// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastTextField extends StatefulWidget implements IFastInput {
  final TextEditingController? textEditingController;
  final bool showHelperBoundaries;
  final String? placeholderText;
  final bool allowAutocorrect;

  final String? initialValue;
  final String? captionText;
  final TextAlign textAlign;
  final String? helperText;
  final String labelText;
  final bool isReadOnly;

  @override
  final ValueChanged<String>? onValueChanged;

  @override
  final Duration debounceTimeDuration;

  @override
  final bool shouldDebounceTime;

  @override
  final bool isEnabled;

  ///
  /// Specifies whether the label should have a border.
  ///
  /// Defaults to false.
  ///
  final bool showLabelBorder;

  const FastTextField({
    super.key,
    required this.labelText,
    this.debounceTimeDuration = kFastDebounceTimeDuration,
    this.textAlign = TextAlign.start,
    this.showHelperBoundaries = true,
    this.shouldDebounceTime = false,
    this.allowAutocorrect = false,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.textEditingController,
    this.placeholderText,
    this.onValueChanged,
    this.initialValue,
    this.captionText,
    this.helperText,
    this.showLabelBorder = false,
  });

  @override
  FastTextFieldState createState() => FastTextFieldState();
}

class FastTextFieldState extends State<FastTextField>
    with FastDebounceInputMixin {
  @override
  void dispose() {
    super.dispose();
    unsubscribeToDebouncerEventsIfNeeded();
    debouncer.close();
  }

  @override
  Widget build(BuildContext context) {
    return FastFieldLayout(
      showHelperBoundaries: widget.showHelperBoundaries,
      control: _buildControl(context),
      captionText: widget.captionText,
      helperText: widget.helperText,
      labelText: widget.labelText,
      showLabelBorder: widget.showLabelBorder,
    );
  }

  Widget _buildControl(BuildContext context) {
    return TextFormField(
      readOnly: widget.isReadOnly,
      enabled: !widget.isReadOnly,
      initialValue: widget.initialValue,
      textAlign: widget.textAlign,
      textInputAction: TextInputAction.done,
      autocorrect: widget.allowAutocorrect,
      cursorColor: ThemeHelper.colors.getPrimaryColor(context),
      keyboardType: TextInputType.text,
      style: ThemeHelper.texts.getBodyTextStyle(context).copyWith(
            fontWeight: kFastFontWeightBold,
          ),
      decoration: InputDecoration(hintText: widget.placeholderText),
      onChanged: debounceOnValueChangedIfNeeded(),
    );
  }
}
