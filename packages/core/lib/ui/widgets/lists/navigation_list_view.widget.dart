// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationListView<T extends FastItem> extends StatefulWidget {
  final FastListItemBuilder<T>? listItemBuilder;
  final ValueChanged<T> onSelectionChanged;
  final EdgeInsets? itemContentPadding;
  final String? searchPlaceholderText;
  final bool shouldUseFuzzySearch;
  final bool isViewScrollable;
  final Widget? clearSearchIcon;
  final bool showItemDivider;
  final EdgeInsets padding;
  final bool showSearchBar;
  final bool sortItems;
  final bool isEnabled;
  final List<T> items;
  final bool showTrailing;
  final bool showLeading;
  final FastEmptyListBuilder<T>? emptyContentBuilder;
  final String? emptyText;

  const FastNavigationListView({
    super.key,
    required this.onSelectionChanged,
    required this.items,
    this.searchPlaceholderText,
    this.clearSearchIcon,
    this.shouldUseFuzzySearch = false,
    this.padding = EdgeInsets.zero,
    this.isViewScrollable = true,
    this.showItemDivider = false,
    this.showSearchBar = false,
    this.sortItems = true,
    this.isEnabled = true,
    this.showTrailing = true,
    this.showLeading = true,
    this.itemContentPadding,
    this.listItemBuilder,
    this.emptyContentBuilder,
    this.emptyText,
  });

  @override
  FastNavigationListViewState<T> createState() =>
      FastNavigationListViewState<T>();
}

class FastNavigationListViewState<T extends FastItem>
    extends State<FastNavigationListView<T>> {
  List<T>? _suggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSearchBar)
          FastSearchBar(
            shouldUseFuzzySearch: widget.shouldUseFuzzySearch,
            items: widget.items,
            showLeadingIcon: false,
            onSuggestions: (List<T>? suggestions, String? query) {
              setState(() => _suggestions = suggestions);
            },
            placeholderText: widget.searchPlaceholderText,
            clearSearchIcon: widget.clearSearchIcon,
          ),
        Expanded(
          child: FastListViewLayout<T>(
            listItemBuilder: _buildListItem,
            items: _suggestions ?? widget.items,
            isViewScrollable: widget.isViewScrollable,
            showItemDivider: widget.showItemDivider,
            sortItems: widget.shouldUseFuzzySearch ? false : widget.sortItems,
            padding: widget.padding,
            emptyContentBuilder: widget.emptyContentBuilder,
            emptyText: widget.emptyText,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, T item, int index) {
    if (widget.listItemBuilder != null) {
      return widget.listItemBuilder!(context, item, index);
    }

    return _buildNavigationListItem(context, item);
  }

  Widget _buildNavigationListItem(BuildContext context, T item) {
    return FastNavigationListItem(
      contentPadding: item.descriptor?.padding ?? widget.itemContentPadding,
      showTrailing: widget.showTrailing,
      showLeading: widget.showLeading,
      item: item,
      onTap: () {
        if (widget.isEnabled && item.isEnabled) {
          FocusScope.of(context).unfocus();
          widget.onSelectionChanged(item);
        }
      },
    );
  }
}
