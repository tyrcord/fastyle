// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:


//TODO: @need-review: code from fastyle_dart

const _kHeaderPadding = 16.0;
const _kContentPadding32 = EdgeInsets.symmetric(vertical: 32);
const _kContentPadding16 = EdgeInsets.symmetric(vertical: _kHeaderPadding);

class FastHomePageLayout extends StatefulWidget {
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

  final ScrollController? scrollController;

  const FastHomePageLayout({
    super.key,
    required this.children,
    this.appBarExpandedHeight = kFastExpandedHeight,
    this.appBarBackgroundLinearGradient,
    this.appBarBackgroundColor,
    this.floatingActionButton,
    this.appBarDecoration,
    this.scrollController,
    this.contentPadding,
    this.subtitleText,
    this.titleText,
    this.actions,
    this.leading,
  }) : assert(
          appBarExpandedHeight >= kFastExpandedHeight ? true : false,
        );

  @override
  FastHomePageLayoutState createState() => FastHomePageLayoutState();
}

class FastHomePageLayoutState extends State<FastHomePageLayout> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          FastAppBarLayout(
            backgroundLinearGradient: widget.appBarBackgroundLinearGradient,
            backgroundColor: widget.appBarBackgroundColor,
            expandedHeight: widget.appBarExpandedHeight,
            decoration: widget.appBarDecoration,
            subtitleText: widget.subtitleText,
            titleText: widget.titleText,
            actions: widget.actions,
            leading: widget.leading,
            scrollController: _scrollController,
          ),
          _buildContent(context),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildContent(BuildContext context) {
    final padding = _getContentPadding(context);

    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        sliver: SliverList(delegate: SliverChildListDelegate(widget.children)),
        padding: padding,
      ),
    );
  }

  EdgeInsetsGeometry _getContentPadding(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    if (size.width >= FastMediaBreakpoints.tablet) {
      return _kContentPadding32;
    }

    return _kContentPadding16;
  }
}
