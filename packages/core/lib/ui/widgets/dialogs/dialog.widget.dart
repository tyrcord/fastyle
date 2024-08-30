import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';

class FastDialog extends AlertDialog {
  final BoxConstraints? constraints;
  final List<Widget> children;
  final String? titleText;
  final Color? titleColor;
  final bool applyMinimumConstraints;

  const FastDialog({
    super.key,
    required this.children,
    this.applyMinimumConstraints = false,
    super.backgroundColor,
    this.constraints,
    this.titleColor,
    this.titleText,
    super.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(child: _buildContent(context)),
      surfaceTintColor: _getBackgroundColor(context),
      contentPadding: _getContentPadding(),
      actionsPadding: _getActionsPadding(),
      titlePadding: _getTitlePadding(),
      clipBehavior: Clip.antiAlias,
      title: _buildTitle(),
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final content = ListBody(children: [...children, kFastVerticalSizedBox16]);

    if (constraints != null) {
      return ConstrainedBox(constraints: constraints!, child: content);
    }

    return applyMinimumConstraints
        ? _buildAdaptiveContent(context, content)
        : content;
  }

  Widget _buildAdaptiveContent(BuildContext context, Widget list) {
    return FastMediaLayoutBuilder(builder: (context, mediaType) {
      final mediaQuerySize = MediaQuery.sizeOf(context);
      final (heightMultiplier, widthMultiplier) = _getMultipliers(mediaType);

      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: mediaQuerySize.height * heightMultiplier,
          minWidth: mediaQuerySize.width * widthMultiplier,
        ),
        child: list,
      );
    });
  }

  (double, double) _getMultipliers(FastMediaType mediaType) {
    switch (mediaType) {
      case FastMediaType.handset:
        return (0.30, 0.75);
      case FastMediaType.tablet:
        return (0.35, 0.50);
      default:
        return (0.25, 0.40);
    }
  }

  Widget? _buildTitle() {
    if (titleText != null) {
      return FastTitle(text: titleText!, textColor: titleColor);
    }

    return null;
  }

  Color _getBackgroundColor(BuildContext context) {
    return backgroundColor ??
        ThemeHelper.colors.getSecondaryBackgroundColor(context);
  }

  EdgeInsets _getTitlePadding() {
    if (titleText != null) {
      return const EdgeInsets.only(
        top: 16.0,
        bottom: 32.0,
        left: 16.0,
        right: 16.0,
      );
    }

    return const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0);
  }

  EdgeInsetsGeometry _getActionsPadding() {
    return const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0);
  }

  EdgeInsets _getContentPadding() {
    if (titleText != null) {
      return const EdgeInsets.only(left: 16.0, right: 16.0);
    }

    return const EdgeInsets.only(top: 48.0, left: 16.0, right: 16.0);
  }
}
