// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';

/// A card that displays a summary of a plan.
class FastPlanSummaryCard extends StatelessWidget {
  /// A builder that returns the icon widget.
  final WidgetBuilder? iconBuilder;

  /// The text to display as the title.
  final String? titleText;

  /// The color of the title text.
  final Color? titleColor;

  /// The widget to display as the footer.
  final Widget? footer;

  /// The widget to display as the icon.
  final Widget? icon;

  const FastPlanSummaryCard({
    Key? key,
    this.iconBuilder,
    this.titleText,
    this.titleColor,
    this.icon,
    this.footer,
  })  : assert(icon == null || iconBuilder == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastShadowLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(),
          _buildIcon(),
          kFastSizedBox8,
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Builds the title widget.
  Widget _buildTitle() {
    if (titleText == null) {
      return const SizedBox.shrink();
    }

    return FastPadding8(
      child: FastTitle(
        text: titleText!,
        textColor: titleColor,
        textAlign: TextAlign.center,
        fontWeight: kFastFontWeightSemiBold,
      ),
    );
  }

  /// Builds the icon widget.
  Widget _buildIcon() {
    if (icon != null) {
      return _buildIconLayout(icon!);
    }

    if (iconBuilder != null) {
      try {
        return _buildIconLayout(Builder(builder: iconBuilder!));
      } catch (e) {
        debugPrint('Error building icon: $e');
      }
    }

    return const SizedBox.shrink();
  }

  /// Builds the icon layout widget.
  ///
  /// [icon] is the widget to display as the icon.
  Widget _buildIconLayout(Widget icon) {
    return Padding(
      padding: kFastEdgeInsets8,
      child: icon,
    );
  }

  /// Builds the footer widget.
  ///
  /// [context] is the build context.
  Widget _buildFooter(BuildContext context) {
    if (footer == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FastDivider(color: ThemeHelper.colors.getShadowColor(context)),
        FastPadding8(child: footer!),
      ],
    );
  }
}
