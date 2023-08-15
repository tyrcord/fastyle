// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSearchableListView<T extends FastItem> extends StatefulWidget {
  ///
  /// Text that describes the all category.
  ///
  final String? allCategoryText;

  ///
  /// Indicates the initial category selected.
  ///
  final int intialCategoryIndex;

  ///
  /// Indicates whether the list should be displayed as a tab view
  /// and grouped by categories.
  ///
  final bool groupByCategory;

  final FastListItemBuilder<T>? listItemBuilder;
  final ValueChanged<T>? onSelectionChanged;
  final EdgeInsets? itemContentPadding;
  final String searchPlaceholderText;
  final bool shouldUseFuzzySearch;
  final bool isViewScrollable;
  final Widget? clearSearchIcon;
  final bool showItemDivider;
  final EdgeInsets? padding;
  final bool showSearchBar;
  final bool sortItems;
  final bool isEnabled;
  final List<T> items;
  final bool showTrailing;
  final bool showLeading;

  /// A function that creates additional tab views.
  final List<FastListItemCategory<T>> Function()? extraTabBuilder;

  /// The delegate object that can modify the behavior of the widget.
  final FastListViewLayoutDelegate<T>? delegate;

  final Widget? emptyContent;
  final String? emptyText;

  const FastSearchableListView({
    super.key,
    required this.items,
    this.onSelectionChanged,
    this.searchPlaceholderText = kFastSearchPlaceholderText,
    this.clearSearchIcon,
    this.shouldUseFuzzySearch = false,
    this.padding,
    this.intialCategoryIndex = 0,
    this.groupByCategory = false,
    this.isViewScrollable = true,
    this.showItemDivider = false,
    this.showSearchBar = true,
    this.sortItems = true,
    this.isEnabled = true,
    this.showTrailing = true,
    this.showLeading = true,
    this.extraTabBuilder,
    this.itemContentPadding,
    this.listItemBuilder,
    this.allCategoryText,
    this.delegate,
    this.emptyContent,
    this.emptyText,
  });

  @override
  State<StatefulWidget> createState() => _FastSearchableListViewState<T>();
}

class _FastSearchableListViewState<T extends FastItem>
    extends State<FastSearchableListView<T>> {
  List<T>? _suggestions;

  @override
  Widget build(BuildContext context) {
    Widget list = FastListViewLayout<T>(
      listItemBuilder: _buildListItems,
      items: _suggestions ?? widget.items,
      isViewScrollable: widget.isViewScrollable,
      showItemDivider: widget.showItemDivider,
      sortItems: widget.shouldUseFuzzySearch ? false : widget.sortItems,
      intialCategoryIndex: widget.intialCategoryIndex,
      allCategoryText: widget.allCategoryText,
      groupByCategory: widget.groupByCategory,
      extraTabBuilder: widget.extraTabBuilder,
      emptyContent: widget.emptyContent,
      delegate: widget.delegate,
      emptyText: widget.emptyText,
      padding:
          widget.padding ?? ThemeHelper.spacing.getHorizontalPadding(context),
    );

    if (widget.isViewScrollable) {
      list = Expanded(child: list);
    }

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
        list,
      ],
    );
  }

  Widget _buildListItems(BuildContext context, T item, int index) {
    if (widget.listItemBuilder != null) {
      return widget.listItemBuilder!(context, item, index);
    }

    return _buildListItem(context, item);
  }

  Widget _buildListItem(BuildContext context, T item) {
    return FastListItemLayout(
      contentPadding: widget.itemContentPadding,
      labelText: item.labelText,
      onTap: () {
        if (widget.isEnabled && item.isEnabled) {
          FocusScope.of(context).unfocus();

          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(item);
          }
        }
      },
    );
  }
}
