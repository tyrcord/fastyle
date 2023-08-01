// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:
import 'package:fastyle_home/fastyle_home.dart';

class FastHomeGraphPage extends StatefulWidget {
  ///
  /// The padding for the page.
  ///
  final EdgeInsetsGeometry? contentPadding;

  ///
  /// A button displayed floating above body, in the bottom right corner.
  ///
  final Widget? floatingActionButton;

  ///
  /// The widgets below the app bar in the tree.
  ///
  final List<Widget> children;

  ///
  /// The size of the app bar when it is fully expanded.
  ///
  final double appBarExpandedHeight;

  ///
  /// A list of Widgets to display in a row after the title.
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

  ///
  /// A widget to display before the toolbar's title.
  ///
  final Widget? leading;

  final LinearGradient? appBarBackgroundLinearGradient;

  final Color? appBarBackgroundColor;

  final Widget? appBarDecoration;

  final FastHomeGraphType graphType;

  const FastHomeGraphPage({
    super.key,
    required this.children,
    this.graphType = FastHomeGraphType.line,
    this.appBarExpandedHeight = kFastExpandedHeight,
    this.appBarBackgroundLinearGradient,
    this.contentPadding,
    this.appBarBackgroundColor,
    this.floatingActionButton,
    this.appBarDecoration,
    this.subtitleText,
    this.titleText,
    this.actions,
    this.leading,
  })  : assert(
          appBarExpandedHeight >= kFastExpandedHeight ? true : false,
        );

  @override
  FastHomePageState createState() => FastHomePageState();
}

class FastHomePageState extends State<FastHomeGraphPage>
    with TickerProviderStateMixin {
  //TODO: Stop animation when not visible anymore
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2520),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FastHomePageLayout(
      appBarBackgroundLinearGradient: widget.appBarBackgroundLinearGradient,
      appBarBackgroundColor: widget.appBarBackgroundColor,
      appBarExpandedHeight: widget.appBarExpandedHeight,
      floatingActionButton: widget.floatingActionButton,
      appBarDecoration: _buildGraph(context),
      contentPadding: widget.contentPadding,
      subtitleText: widget.subtitleText,
      titleText: widget.titleText,
      actions: widget.actions,
      leading: widget.leading,
      children: widget.children,
    );
  }

  Widget _buildGraph(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    if (widget.graphType == FastHomeGraphType.pie) {
      return _buildPieGraph(context, palette);
    }

    return _buildLineGraph(context, palette);
  }

  Widget _buildLineGraph(BuildContext context, FastPaletteColors palette) {
    final whiteColor = palette.whiteColor;

    return RepaintBoundary(
      child: CustomPaint(
        painter: FastLineGraphAppBarPainter(
          backgroundColor: whiteColor,
          borderColor: whiteColor,
          cursorColor: whiteColor,
          backgroundOpacity: 0.15,
          borderOpacity: 0.65,
        ),
        foregroundPainter: FastAnimatedLineGraphCursorPainter(
          animation: _animation,
          color: whiteColor,
        ),
      ),
    );
  }

  Widget _buildPieGraph(BuildContext context, FastPaletteColors palette) {
    final whiteColor = palette.whiteColor;

    return RepaintBoundary(
      child: CustomPaint(
        painter: FastPieGraphAppBarPainter(
          backgroundColor: whiteColor,
          backgroundOpacity: 0.15,
          borderColor: whiteColor,
          borderOpacity: 0.65,
        ),
        foregroundPainter: FastAnimatedPieGraphPainter(
          backgroundColor: whiteColor,
          borderColor: whiteColor,
          backgroundOpacity: 0.35,
          animation: _animation,
          borderOpacity: 0.65,
        ),
      ),
    );
  }
}
