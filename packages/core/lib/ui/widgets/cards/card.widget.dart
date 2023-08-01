// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastCard extends StatelessWidget {
  final List<Widget>? headerActions;
  final List<Widget>? footerActions;
  final Color? backgroundColor;
  final Color? titleTextColor;
  final EdgeInsets? padding;
  final Color? shadowColor;
  final String titleText;
  final Widget? child;

  const FastCard({
    super.key,
    required this.titleText,
    this.backgroundColor,
    this.titleTextColor,
    this.headerActions,
    this.footerActions,
    this.shadowColor,
    this.padding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FastShadowLayout(
      shadowColor: shadowColor,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(),
          if (child != null) _buildContent(),
          if (footerActions != null) _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final hasHeaderActions = headerActions != null;
    final customPadding = hasHeaderActions ? 8.0 : 16.0;

    return Container(
      constraints: const BoxConstraints(minHeight: 52.0),
      padding: EdgeInsets.only(
        left: 16.0,
        right: customPadding,
        top: customPadding,
        bottom: child == null && footerActions == null ? 16.0 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: hasHeaderActions
                  ? const EdgeInsets.only(right: 8.0)
                  : EdgeInsets.zero,
              child: FastTitle(text: titleText, textColor: titleTextColor),
            ),
          ),
          if (headerActions != null)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[...headerActions!],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: footerActions != null ? 8.0 : 16.0,
        top: 8.0,
      ),
      child: child,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
        top: child == null ? 8.0 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[...footerActions!],
      ),
    );
  }
}
