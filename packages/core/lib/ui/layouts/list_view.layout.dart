// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const kFastListTileCategoryAll = FastInternalCategory(
  labelText: CoreLocaleKeys.core_label_all,
  valueText: 'all',
  weight: 1000,
);

typedef FastEmptyListBuilder<T extends FastItem> = Widget? Function(
  BuildContext context,
  FastListItemCategory<T>,
);

/// A widget that creates a list view with customizable features.
class FastListViewLayout<T extends FastItem> extends StatelessWidget {
  /// The function that creates a list item for a given index and item.
  final FastListItemBuilder<T> listItemBuilder;

  /// The list of items to display.
  final List<T> items;

  /// The amount of padding around the content.
  final EdgeInsets? padding;

  /// The index of the initial category to display.
  final int intialCategoryIndex;

  /// A boolean indicating whether to group items by category.
  final bool groupByCategory;

  /// A boolean indicating whether the view is scrollable.
  final bool isViewScrollable;

  /// A boolean indicating whether to show a thin horizontal line between items.
  final bool showItemDivider;

  /// A boolean indicating whether to sort the items.
  final bool sortItems;

  /// A function that creates additional tab views.
  final List<FastListItemCategory<T>> Function()? extraTabBuilder;

  /// The text that describes the all category.
  final String? allCategoryText;

  /// The delegate object that can modify the behavior of the widget.
  final FastListViewLayoutDelegate<T>? delegate;

  /// The scroll controller used to control the list view's scrolling behavior.
  final scrollController = ScrollController();

  final FastEmptyListBuilder<T>? emptyContentBuilder;

  final String? emptyText;

  /// Creates a new `FastListViewLayout` widget.
  ///
  /// The `listItemBuilder` and `items` parameters are required.
  FastListViewLayout({
    super.key,
    required this.listItemBuilder,
    required this.items,
    this.padding,
    this.intialCategoryIndex = 0,
    this.groupByCategory = false,
    this.isViewScrollable = true,
    this.showItemDivider = false,
    this.sortItems = true,
    this.extraTabBuilder,
    this.allCategoryText,
    this.emptyContentBuilder,
    this.emptyText,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final elements = [...items];

    // If groupByCategory is true, display a tab view with categories
    if (groupByCategory) return _buildTabViews(context, elements);

    // Otherwise, display a standard list view
    return buildListView(
      context,
      FastListItemCategory(
        labelText: CoreLocaleKeys.core_label_all,
        valueText: kFastListTileCategoryAll.valueText,
        items: elements,
      ),
    );
  }

  /// Builds a tab view widget with categories.
  Widget _buildTabViews(BuildContext context, List<T> items) {
    // Group the items into categories
    final listCategories = _buildListCategories(items);

    // If an extraTabBuilder function is provided, call it to add additional
    // categories
    if (extraTabBuilder != null) {
      listCategories.addAll(extraTabBuilder!());
    }

    // Sort the categories by weight in descending order
    listCategories.sort((a, b) => b.weight.compareTo(a.weight));

    // Create a list of tabs and views from the categories
    final views = <Widget>[];
    final tabs = <Tab>[];

    for (final listCategory in listCategories) {
      // Create a tab for the category
      final tab = Tab(text: toBeginningOfSentenceCase(listCategory.labelText));
      Widget? view;

      // If a delegate is provided, call its willBuildListViewForCategory method
      // to customize the list view for the category
      if (delegate != null) {
        view = delegate!.willBuildListViewForCategory(this, listCategory);
      }

      // If a view was not provided by the delegate, create a standard list view
      //for the category
      view ??= buildListView(context, listCategory);

      tabs.add(tab);
      views.add(view);
    }

    return FastTabs(
      initialIndex: intialCategoryIndex,
      tabs: tabs,
      views: views,
    );
  }

  /// Builds a list view with the specified items.
  Widget buildListView(BuildContext context, FastListItemCategory<T> category) {
    final List<T> items = category.items;

    if (items.isEmpty) return _buildEmptyContent(context, category);

    // If the view is scrollable or the items are grouped by category,
    // create a scrollable list view
    if (isViewScrollable || groupByCategory) {
      return _buildScrollableContent(context, items);
    }

    // Otherwise, create a fixed list view
    return _buildFixedContent(context, items);
  }

  Widget _buildEmptyContent(
    BuildContext context,
    FastListItemCategory<T> category,
  ) {
    final emptyContent = emptyContentBuilder?.call(context, category);

    if (emptyContent != null) return emptyContent;

    return Center(
      child: FastSecondaryBody(
        text: emptyText ?? CoreLocaleKeys.core_label_no_elements.tr(),
      ),
    );
  }

  /// Builds a scrollable list view with the specified items.
  Widget _buildScrollableContent(BuildContext context, List<T> items) {
    final dividerDecoration = _buildDividerDecorationIdNeeded(context);
    final rows = _sortItemIfNeeded(items);
    final lastIndex = rows.length - 1;

    // Set the padding for the list view content based on the widget's
    // configuration or the theme's default padding.

    final listViewPadding = padding ?? EdgeInsets.zero;

    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        padding: listViewPadding,
        itemCount: rows.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(
            context: context,
            item: rows[index],
            index: index,
            isLastItem: index < lastIndex,
            decoration: dividerDecoration,
          );
        },
      ),
    );
  }

  /// Builds a fixed list view with the specified items.
  Widget _buildFixedContent(BuildContext context, List<T> items) {
    final dividerDecoration = _buildDividerDecorationIdNeeded(context);
    final rows = _sortItemIfNeeded(items);
    final lastIndex = rows.length - 1;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.asMap().entries.map((MapEntry<int, T> entry) {
          return _buildListItem(
            context: context,
            item: entry.value,
            index: entry.key,
            isLastItem: entry.key < lastIndex,
            decoration: dividerDecoration,
          );
        }).toList(),
      ),
    );
  }

  /// Builds a decoration for item dividers if needed.
  BoxDecoration? _buildDividerDecorationIdNeeded(BuildContext context) {
    return showItemDivider ? ThemeHelper.createBorderSide(context) : null;
  }

  /// Sorts the items if sortItems is true.
  List<T> _sortItemIfNeeded(List<T> items) {
    if (sortItems) {
      items = items.map((T item) {
        return item.copyWith(
          normalizedLabelText: removeDiacriticsAndLowercase(
            item.labelText,
          ),
        ) as T;
      }).toList()
        ..sort(
          (a, b) => a.normalizedLabelText!.compareTo(b.normalizedLabelText!),
        );
    }

    return items;
  }

  /// Groups the items into categories.
  List<FastListItemCategory<T>> _buildListCategories(List<T> items) {
    final categoriesMap = {
      kFastListTileCategoryAll.valueText: _buildListCategory(
        kFastListTileCategoryAll.copyWith(
          labelText: allCategoryText ?? kFastListTileCategoryAll.labelText.tr(),
        ),
      ),
    };

    final allCategory =
        categoriesMap[kFastListTileCategoryAll.valueText]!.items;

    for (final item in items) {
      if (!allCategory.contains(item)) allCategory.add(item);

      item.categories?.forEach((FastCategory category) {
        if (!categoriesMap.containsKey(category.valueText)) {
          categoriesMap[category.valueText] = _buildListCategory(category);
        }

        categoriesMap[category.valueText]!.items.add(item);
      });
    }

    final categories = categoriesMap.values.toList();

    return categories;
  }

  FastListItemCategory<T> _buildListCategory(FastCategory category) {
    return FastListItemCategory(
      labelText: category.labelText,
      valueText: category.valueText,
      weight: category.weight,
      // ignore: prefer_const_literals_to_create_immutables
      items: <T>[],
    );
  }

  Widget _buildListItem({
    required bool isLastItem,
    required T item,
    required BuildContext context,
    required int index,
    BoxDecoration? decoration,
  }) {
    final listItem = listItemBuilder(context, item, index);

    if (isLastItem && decoration != null) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: decoration,
        child: listItem,
      );
    }

    return listItem;
  }
}
