// Flutter imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

//TODO: @need-review: code from fastyle_dart

class FastSearchField extends StatefulWidget implements IFastInput {
  final TextEditingController? textEditingController;
  final String? placeholderText;
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
    this.placeholderText,
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
        hintText:
            widget.placeholderText ?? CoreLocaleKeys.core_message_search.tr(),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      style: ThemeHelper.texts.getTitleTextStyle(context),
      onChanged: debounceOnValueChangedIfNeeded(),
    );
  }
}
