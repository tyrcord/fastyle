// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastTabs extends StatelessWidget {
  final TextStyle? unselectedLabelStyle;
  final Color? unselectedLabelColor;
  final double? indicatorWeight;
  final Color? indicatorColor;
  final TextStyle? labelStyle;
  final bool isViewScrollable;
  final List<Widget> views;
  final Color? labelColor;
  final int initialIndex;
  final List<Tab> tabs;

  const FastTabs({
    super.key,
    required this.tabs,
    required this.views,
    this.isViewScrollable = true,
    this.initialIndex = 0,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.indicatorWeight,
    this.indicatorColor,
    this.labelColor,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: initialIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
            indicatorWeight: indicatorWeight ?? ThemeHelper.borderSize,
            isScrollable: isViewScrollable,
            indicatorColor:
                indicatorColor ?? ThemeHelper.colors.getPrimaryColor(context),
            labelColor: labelColor,
            labelStyle: labelStyle,
            unselectedLabelColor: unselectedLabelColor,
            unselectedLabelStyle: unselectedLabelStyle,
            dividerColor: Colors.transparent,
            tabs: tabs,
            tabAlignment: TabAlignment.start,
          ),
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
