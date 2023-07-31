// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationBarView extends StatefulWidget {
  final List<FastNavigationDestination> destinations;
  final void Function(int)? onDestinationSelected;
  final Widget? child;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final bool showAppBar;

  const FastNavigationBarView({
    super.key,
    required this.destinations,
    this.showAppBar = true,
    this.onDestinationSelected,
    this.backgroundColor,
    this.indicatorColor,
    this.child,
  });

  @override
  State<FastNavigationBarView> createState() => _FastNavigationBarViewState();
}

class _FastNavigationBarViewState extends State<FastNavigationBarView> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FastMediaLayoutBuilder(
      builder: (context, mediaType) {
        var indicatorColor = widget.indicatorColor;
        indicatorColor ??= ThemeHelper.colors.getPrimaryColor(context);

        if (mediaType >= FastMediaType.tablet) {
          return FastScaffold(
            showAppBar: widget.showAppBar,
            child: buildNavigationRail(context, widget.child, indicatorColor),
          );
        }

        final theme = Theme.of(context);

        return NavigationBarTheme(
          data: theme.navigationBarTheme.copyWith(
            indicatorColor: indicatorColor,
          ),
          child: FastScaffold(
            bottomNavigationBar: buildNavigationBar(context),
            showAppBar: widget.showAppBar,
            child: widget.child,
          ),
        );
      },
    );
  }

  NavigationBar buildNavigationBar(BuildContext context) {
    final colors = ThemeHelper.colors;
    final backgroundColor =
        widget.backgroundColor ?? colors.getSecondaryBackgroundColor(context);

    return NavigationBar(
      destinations: _buildNavigationDestinationList(),
      onDestinationSelected: _handleSelectionChange,
      selectedIndex: _findSelectedIndex(context),
      surfaceTintColor: backgroundColor,
      backgroundColor: backgroundColor,
    );
  }

  Widget buildNavigationRail(
    BuildContext context,
    Widget? selectedPage,
    Color indicatorColor,
  ) {
    return Row(
      children: <Widget>[
        NavigationRail(
          destinations: _buildNavigationRailDestinationList(),
          onDestinationSelected: _handleSelectionChange,
          labelType: NavigationRailLabelType.all,
          selectedIndex: _findSelectedIndex(context),
          indicatorColor: indicatorColor,
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(child: selectedPage ?? const SizedBox.shrink()),
      ],
    );
  }

  int _findSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final index = widget.destinations.toList().indexWhere((element) {
      return location.startsWith(element.path);
    });

    return index >= 0 ? index : 0;
  }

  void _handleSelectionChange(int index) {
    if (widget.onDestinationSelected != null) {
      widget.onDestinationSelected!(index);
    } else {
      context.go(widget.destinations[index].path);
    }
  }

  List<NavigationDestination> _buildNavigationDestinationList() {
    return widget.destinations.map<NavigationDestination>((destination) {
      return destination.toNavigationDestination();
    }).toList();
  }

  List<NavigationRailDestination> _buildNavigationRailDestinationList() {
    return widget.destinations.map<NavigationRailDestination>((destination) {
      return destination.toNavigationRailDestination();
    }).toList();
  }
}
