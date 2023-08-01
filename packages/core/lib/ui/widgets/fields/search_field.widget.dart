// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSearchField extends StatefulWidget implements IFastInput {
  final TextEditingController? textEditingController;
  final String placeholderText;
  final bool allowAutocorrect;
  final TextAlign textAlign;
  final EdgeInsets margin;
  final bool isReadOnly;

  @override
  final ValueChanged<String>? onValueChanged;

  @override
  final Duration debounceTimeDuration;

  @override
  final bool shouldDebounceTime;

  @override
  final bool isEnabled;

  const FastSearchField({
    super.key,
    this.debounceTimeDuration = kFastDebounceTimeDuration,
    this.placeholderText = kFastSearchPlaceholderText,
    this.margin = const EdgeInsets.only(bottom: 8.0),
    this.textAlign = TextAlign.start,
    this.shouldDebounceTime = false,
    this.allowAutocorrect = false,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.textEditingController,
    this.onValueChanged,
  });

  @override
  FastSearchFieldState createState() => FastSearchFieldState();
}

class FastSearchFieldState extends State<FastSearchField>
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
      margin: widget.margin,
      control: _buildControl(context),
      showHelperBoundaries: false,
    );
  }

  Widget _buildControl(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      readOnly: widget.isReadOnly,
      textAlign: widget.textAlign,
      enabled: widget.isEnabled,
      textInputAction: TextInputAction.search,
      autocorrect: widget.allowAutocorrect,
      cursorColor: ThemeHelper.colors.getPrimaryColor(context),
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: widget.placeholderText,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      style: ThemeHelper.texts.getTitleTextStyle(context),
      onChanged: debounceOnValueChangedIfNeeded(),
    );
  }
}
