import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:t_helpers/helpers.dart';

mixin FastPendingButtonMixin<T extends FastButton2> on State<T> {
  @protected
  final GlobalKey buttonKey = GlobalKey();

  BoxConstraints? _buttonConstraints;
  late Throttler _throttler;
  double? _previousWidth;

  @override
  void initState() {
    super.initState();
    _throttler = Throttler(milliseconds: 4);
    WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
  }

  @override
  void dispose() {
    _throttler.dispose();
    super.dispose();
  }

  @protected
  void updateConstraints() {
    _throttler.run(() => _updateConstraints());
  }

  @protected
  void _updateConstraints() {
    final currenContext = buttonKey.currentContext;
    final renderBox = currenContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      final padding = widget.padding ?? EdgeInsets.zero;
      final borderWidth = widget.borderWidth * 2;
      final width = renderBox.size.width - padding.horizontal - borderWidth;

      // Get the parent constraints
      final parentConstraints = renderBox.constraints;

      // Ensure the calculated width is not larger than the parent's max width
      final safeWidth = width.clamp(0.0, parentConstraints.maxWidth);

      if (safeWidth != _previousWidth) {
        setState(() {
          _buttonConstraints = BoxConstraints(
            maxWidth: safeWidth,
            minWidth: safeWidth,
          ).normalize(); // Normalize to ensure min <= max

          _previousWidth = safeWidth;
        });
      }
    }
  }

  @protected
  Widget buildPendingIndicator(BuildContext context) {
    return Container(
      constraints: _buttonConstraints,
      child: FastThreeBounceIndicator(color: getIndicatorColor(context)),
    );
  }

  @protected
  Color? getIndicatorColor(BuildContext context);
}
