// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kSuffixIcon = SizedBox(width: 40, height: 33);
const _kSuffixIconConstraints = BoxConstraints(maxWidth: 40, maxHeight: 33);

class FastNumberField extends StatefulWidget implements IFastInput {
  final TextEditingController? textEditingController;
  final BoxConstraints? suffixIconConstraints;
  final VoidCallback? onEditingCompleted;
  final bool transformInvalidNumber;
  final bool showHelperBoundaries;
  final String? placeholderText;
  final bool allowAutocorrect;
  final TextAlign textAlign;
  final String? captionText;
  final Widget? suffixIcon;
  final bool acceptDecimal;
  final String? helperText;
  final String labelText;
  final String valueText;
  final bool isReadOnly;
  final String? locale;
  final int maxLength;
  final int maxValue;

  ///
  /// Specifies whether the label should have a border.
  ///
  /// Defaults to false.
  ///
  final bool showLabelBorder;

  @override
  final ValueChanged<String>? onValueChanged;

  @override
  final Duration debounceTimeDuration;

  @override
  final bool shouldDebounceTime;

  @override
  final bool isEnabled;

  const FastNumberField({
    super.key,
    required this.labelText,
    this.maxLength = NumberInputFormatter.safeIntegerMaxLength,
    this.debounceTimeDuration = kFastDebounceTimeDuration,
    this.maxValue = NumberInputFormatter.safeInteger,
    this.transformInvalidNumber = true,
    this.showHelperBoundaries = true,
    this.textAlign = TextAlign.start,
    this.shouldDebounceTime = false,
    this.allowAutocorrect = false,
    this.acceptDecimal = true,
    this.isReadOnly = false,
    this.isEnabled = true,
    String? valueText,
    this.textEditingController,
    this.suffixIconConstraints,
    this.onEditingCompleted,
    this.placeholderText,
    this.onValueChanged,
    this.captionText,
    this.helperText,
    this.suffixIcon,
    this.locale,
    this.showLabelBorder = false,
  }) : valueText = valueText ?? '';

  @override
  FastNumberFieldState createState() => FastNumberFieldState();
}

class FastNumberFieldState extends State<FastNumberField>
    with FastDebounceInputMixin {
  late TextEditingController _controller;
  bool _isInitialized = false;

  @override
  void dispose() {
    super.dispose();
    unsubscribeToDebouncerEventsIfNeeded();
    debouncer.close();

    if (_controller != widget.textEditingController) {
      _controller.dispose();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final controller = widget.textEditingController;
      final value = widget.valueText;

      _controller = controller ?? TextEditingController(text: value);
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(FastNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final value = widget.valueText;

    if (oldWidget.valueText != value || _controller.text != value) {
      final position = TextPosition(offset: value.length);
      final selection = TextSelection.fromPosition(position);

      _controller.value = TextEditingValue(text: value, selection: selection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastFieldLayout(
      labelText: widget.labelText,
      captionText: widget.captionText,
      helperText: widget.helperText,
      control: _buildControl(context),
      suffixIcon: widget.suffixIcon,
      showHelperBoundaries: widget.showHelperBoundaries,
      showLabelBorder: widget.showLabelBorder,
    );
  }

  Widget _buildControl(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);

    return TextFormField(
      cursorColor: ThemeHelper.colors.getPrimaryColor(context),
      onEditingComplete: widget.onEditingCompleted,
      onChanged: debounceOnValueChangedIfNeeded(),
      textInputAction: TextInputAction.done,
      autocorrect: widget.allowAutocorrect,
      textAlign: widget.textAlign,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: widget.acceptDecimal,
      ),
      decoration: InputDecoration(
        hintText: widget.placeholderText,
        suffixIcon: widget.suffixIcon != null ? _kSuffixIcon : null,
        suffixIconConstraints: _kSuffixIconConstraints,
      ),
      style: bodyTextStyle.copyWith(
        fontWeight: kFastFontWeightBold,
      ),
      inputFormatters: [
        NumberInputFormatter(
          maxLength: widget.maxLength,
          maxValue: widget.maxValue,
          allowDecimals: widget.acceptDecimal,
          transformInvalidNumber: widget.transformInvalidNumber,
        ),
      ],
    );
  }
}
