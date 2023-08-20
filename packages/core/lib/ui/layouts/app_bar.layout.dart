// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastAppBarLayout extends StatefulWidget {
  ///
  /// The size of the app bar when it is fully expanded.
  ///
  final double expandedHeight;

  ///
  /// A widget to display on the left side.
  ///
  final Widget? leading;

  ///
  /// A list of Widgets to display in a row on the right side.
  ///
  final List<Widget>? actions;

  ///
  /// Text displayed below the title.
  /// Typically, a description of the current contents of the app.
  ///
  final String? subtitleText;

  ///
  /// Title of the app.
  ///
  final String? titleText;

  final Widget? decoration;

  final Color? backgroundColor;

  final LinearGradient? backgroundLinearGradient;

  final ScrollController scrollController;

  const FastAppBarLayout({
    super.key,
    required this.scrollController,
    this.expandedHeight = kFastExpandedHeight,
    this.subtitleText,
    this.titleText,
    this.leading,
    this.actions,
    this.decoration,
    this.backgroundColor,
    this.backgroundLinearGradient,
  });

  @override
  FastAppBarLayoutState createState() => FastAppBarLayoutState();
}

class FastAppBarLayoutState extends State<FastAppBarLayout> {
  late final ScrollController _scrollController;
  double _decorationOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController;
    _scrollController.addListener(_onScrollNoticiation);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      surfaceTintColor: ThemeHelper.colors.getSurfaceTintColor(context),
      leading: widget.leading,
      expandedHeight: widget.expandedHeight,
      backgroundColor: Colors.transparent,
      actions: widget.actions,
      stretch: true,
      pinned: true,
      flexibleSpace: Stack(
        children: [
          _buildBackground(context),
          SafeArea(
            top: true,
            left: false,
            right: false,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: _buildDecoration(context)),
                if (widget.titleText != null || widget.subtitleText != null)
                  Positioned(
                    bottom: 0,
                    child: SafeArea(
                      child: Opacity(
                        opacity: _decorationOpacity,
                        child: _buildTitling(context),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      systemOverlayStyle: _getSystemOverlayStyle(context),
    );
  }

  Widget _buildDecoration(BuildContext context) {
    if (widget.decoration != null) {
      return Opacity(
        opacity: _decorationOpacity,
        child: widget.decoration!,
      );
    }

    return SizedBox(width: double.infinity, height: widget.expandedHeight);
  }

  Widget _buildBackground(BuildContext context) {
    if (widget.backgroundColor != null) {
      return Container(color: widget.backgroundColor);
    } else if (widget.backgroundLinearGradient != null) {
      return Container(
        decoration: BoxDecoration(gradient: widget.backgroundLinearGradient),
      );
    }

    final gradient = ThemeHelper.gradients.primaryLinearGradient(context);

    return Container(decoration: BoxDecoration(gradient: gradient));
  }

  Widget _buildTitling(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    final textColor = ThemeHelper.colors.getColorWithBestConstrast(
      context: context,
      darkColor: ThemeHelper.texts.getTitleTextStyle(context).color!,
      lightColor: palette.whiteColor,
    );

    return FastPadding16(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.titleText != null)
            FastTitle(
              text: widget.titleText!,
              textColor: textColor,
              maxLines: 1,
            ),
          if (widget.subtitleText != null)
            FastSecondaryBody(
              text: widget.subtitleText!,
              textColor: textColor,
              maxLines: 1,
            ),
        ],
      ),
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final themeBloc = FastThemeBloc.instance;
    final brightness = themeBloc.currentState.brightness;

    if (brightness == Brightness.light) {
      if (widget.backgroundColor != null) {
        return ThemeHelper.colors.getOverlayStyleForColor(
          context: context,
          color: widget.backgroundColor!,
        );
      }

      return ThemeHelper.gradients.getSystemUiOverlayStyleForGradient(
        context: context,
        gradient: widget.backgroundLinearGradient ??
            ThemeHelper.gradients.primaryLinearGradient(context),
      );
    }

    return SystemUiOverlayStyle.light;
  }

  void _onScrollNoticiation() {
    if (_scrollController.hasClients) {
      final threshold = widget.expandedHeight - kToolbarHeight * 1.5;
      final offset = _scrollController.offset;

      if ((offset >= 0 && offset <= threshold) || _decorationOpacity > 0) {
        final distance = threshold - _scrollController.offset;
        final multiplier = _sanitizeOpacity(distance / threshold);

        if (multiplier != _decorationOpacity) {
          setState(() {
            _decorationOpacity = multiplier;
          });
        }
      }
    }
  }

  double _sanitizeOpacity(double opacity) {
    if (opacity.isNegative) {
      opacity = 0.0;
    } else if (opacity > 1) {
      opacity = 1.0;
    }

    return opacity;
  }
}
