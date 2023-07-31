// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastActionCard extends StatelessWidget {
  final List<Widget>? headerActions;
  final List<Widget>? footerActions;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final EdgeInsets? padding;
  final Color? shadowColor;
  final VoidCallback onTap;
  final String titleText;
  final Widget? child;

  const FastActionCard({
    Key? key,
    required this.titleText,
    required this.onTap,
    this.backgroundColor,
    this.titleTextColor,
    this.headerActions,
    this.footerActions,
    this.shadowColor,
    this.padding,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FastCard(
        titleText: titleText,
        titleTextColor: titleTextColor,
        padding: padding,
        headerActions: headerActions,
        footerActions: footerActions,
        shadowColor: shadowColor,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}
