import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';

mixin FastPendingButtonMixin<T extends FastButton2> on State<T> {
  @protected
  final GlobalKey buttonKey = GlobalKey();

  BoxConstraints? _constraints;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateConstraints());
  }

  @protected
  void updateConstraints() {
    final RenderBox? renderBox =
        buttonKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      setState(() {
        final width = renderBox.size.width;
        _constraints = BoxConstraints(maxWidth: width, minWidth: width);
      });
    }
  }

  @protected
  Widget buildPendingIndicator(BuildContext context) {
    return Container(
      constraints: _constraints,
      child: FastThreeBounceIndicator(color: getIndicatorColor(context)),
    );
  }

  @protected
  Color? getIndicatorColor(BuildContext context);
}
