// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastSplitViewShell<T extends FastItem> extends StatefulWidget {
  final FastListItemBuilder<T>? listItemBuilder;
  final EdgeInsets? itemContentPadding;
  final String? searchPlaceholderText;
  final bool shouldUseFuzzySearch;
  final Widget? clearSearchIcon;
  final bool showItemDivider;
  final bool showSearchBar;
  final bool sortItems;
  final bool isEnabled;
  final List<T> items;
  final Widget? detailsPage;
  final ValueChanged<FastItem>? onSelectionChanged;
  final T? selection;

  const FastSplitViewShell({
    super.key,
    required this.items,
    this.detailsPage,
    this.searchPlaceholderText,
    this.clearSearchIcon,
    this.shouldUseFuzzySearch = false,
    this.showItemDivider = false,
    this.showSearchBar = false,
    this.sortItems = true,
    this.isEnabled = true,
    this.itemContentPadding,
    this.listItemBuilder,
    this.onSelectionChanged,
    this.selection,
  });

  @override
  State<FastSplitViewShell> createState() => _FastSplitViewShellState();
}

class _FastSplitViewShellState extends State<FastSplitViewShell> {
  FastItem? _selection;

  @override
  void initState() {
    super.initState();
    _selection = widget.selection;
  }

  @override
  void didUpdateWidget(FastSplitViewShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selection != widget.selection) {
      _selection = widget.selection;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: _buildSplitView(context));
  }

  Widget _buildSplitView(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: FastSplitLayout(
        primaryBuilder: _buildSplitPrimaryView,
        secondaryBuilder: _buildSplitSecondaryView,
      ),
    );
  }

  Widget _buildSplitPrimaryView(BuildContext context) {
    final colors = ThemeHelper.colors;

    return FastSelectableListView(
      searchPlaceholderText: widget.searchPlaceholderText,
      shouldUseFuzzySearch: widget.shouldUseFuzzySearch,
      selectionColor: colors.getPrimaryColor(context),
      itemContentPadding: widget.itemContentPadding,
      clearSearchIcon: widget.clearSearchIcon,
      showItemDivider: widget.showItemDivider,
      listItemBuilder: widget.listItemBuilder,
      showSearchBar: widget.showSearchBar,
      isEnabled: widget.isEnabled,
      sortItems: widget.sortItems,
      selection: _selection,
      items: widget.items,
      onSelectionChanged: (item) {
        _selection = item;
        widget.onSelectionChanged?.call(item);
      },
    );
  }

  Widget _buildSplitSecondaryView(BuildContext context) {
    if (widget.detailsPage != null) {
      return widget.detailsPage!;
    }

    return const SizedBox.shrink();
  }
}
