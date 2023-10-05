// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSplitLayout extends StatelessWidget {
  final FastSplitSupplementaryBehavior supplementaryBehavior;
  final WidgetBuilder? supplementaryBuilder;
  final WidgetBuilder secondaryBuilder;
  final WidgetBuilder primaryBuilder;

  const FastSplitLayout({
    super.key,
    required this.secondaryBuilder,
    required this.primaryBuilder,
    this.supplementaryBehavior = FastSplitSupplementaryBehavior.sideBar,
    this.supplementaryBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (BuildContext context, FastMediaType mediaType) {
        if (mediaType < FastMediaType.tablet) {
          return buildPrimary(context, mediaType);
        }

        return buildSplitLayout(context, mediaType);
      },
    );
  }

  Widget buildSplitLayout(BuildContext context, FastMediaType mediaType) {
    return Row(
      children: [
        buildPrimary(context, mediaType),
        if (supplementaryBehavior == FastSplitSupplementaryBehavior.cascade)
          buildSupplementary(context, mediaType),
        buildSecondary(context, mediaType),
        if (supplementaryBehavior == FastSplitSupplementaryBehavior.sideBar)
          buildSupplementary(context, mediaType),
      ],
    );
  }

  Widget buildPrimary(BuildContext context, FastMediaType mediaType) {
    return Container(
      constraints: BoxConstraints(maxWidth: _getColumnWidth(mediaType)),
      decoration: _getColumnBoxDecoration(context),
      child: Builder(builder: primaryBuilder),
    );
  }

  Widget buildSecondary(BuildContext context, FastMediaType mediaType) {
    return Expanded(
      child: ColoredBox(
        color: _getMasterBackgroundColor(context),
        child: Builder(builder: secondaryBuilder),
      ),
    );
  }

  Widget buildSupplementary(BuildContext context, FastMediaType mediaType) {
    if (supplementaryBuilder != null) {
      final borderPosition =
          supplementaryBehavior == FastSplitSupplementaryBehavior.sideBar
              ? FastPosition.left
              : FastPosition.right;

      return Container(
        constraints: BoxConstraints(maxWidth: _getColumnWidth(mediaType)),
        decoration: _getColumnBoxDecoration(
          context,
          borderPosition: borderPosition,
        ),
        child: Builder(builder: supplementaryBuilder!),
      );
    }

    return const SizedBox.shrink();
  }

  BoxDecoration _getColumnBoxDecoration(
    BuildContext context, {
    FastPosition borderPosition = FastPosition.right,
  }) {
    final borderSide = BorderSide(color: Theme.of(context).dividerColor);
    final isBorderRight = borderPosition == FastPosition.right;

    return BoxDecoration(
      border: Border(
        right: isBorderRight ? borderSide : BorderSide.none,
        left: !isBorderRight ? borderSide : BorderSide.none,
      ),
      color: _getColumnBackgroundColor(context),
    );
  }

  Color _getMasterBackgroundColor(BuildContext context) {
    final secondaryBackground = _getSecondaryBackgroundColor(context);
    final background = _getPrimaryBackgroundColor();
    final brightness = _getAppBrightness(context);

    return brightness == Brightness.dark ? background : secondaryBackground;
  }

  Color _getColumnBackgroundColor(BuildContext context) {
    final secondaryBackground = _getSecondaryBackgroundColor(context);
    final background = _getPrimaryBackgroundColor();
    final brightness = _getAppBrightness(context);

    return brightness == Brightness.dark ? secondaryBackground : background;
  }

  Color _getPrimaryBackgroundColor() {
    return ThemeHelper.colors.getPrimaryBackgroundColor();
  }

  Color _getSecondaryBackgroundColor(BuildContext context) {
    return ThemeHelper.colors.getSecondaryBackgroundColor(context);
  }

  Brightness? _getAppBrightness(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;

    return themeBloc.currentState.brightness;
  }

  double _getColumnWidth(FastMediaType mediaType) {
    if (mediaType <= FastMediaType.xl) {
      return 240;
    } else if (mediaType <= FastMediaType.large) {
      return 220;
    }

    return 200;
  }
}
