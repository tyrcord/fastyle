// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastListView<T extends FastItem> extends StatelessWidget {
  /// A function that creates additional tab views.
  final List<FastListItemCategory<T>> Function()? extraTabBuilder;

  /// The delegate object that can modify the behavior of the widget.
  final FastListViewLayoutDelegate<T>? delegate;

  final FastListItemBuilder<T>? listItemBuilder;
  final EdgeInsets? itemContentPadding;
  final List<FastCategory>? categories;
  final bool useDenseListItem;
  final bool isViewScrollable;
  final bool groupByCategory;
  final bool showItemDivider;
  final bool isEnabled;
  final bool sortItems;
  final List<T> items;
  final EdgeInsets padding;
  final Widget? emptyContent;
  final String? emptyText;

  const FastListView({
    super.key,
    required this.items,
    this.padding = EdgeInsets.zero,
    this.groupByCategory = false,
    this.showItemDivider = false,
    this.useDenseListItem = true,
    this.isViewScrollable = true,
    this.sortItems = true,
    this.isEnabled = true,
    this.extraTabBuilder,
    this.itemContentPadding,
    this.delegate,
    this.listItemBuilder,
    this.categories,
    this.emptyContent,
    this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return FastListViewLayout(
      listItemBuilder: _buildListItems,
      items: items,
      isViewScrollable: isViewScrollable,
      showItemDivider: showItemDivider,
      sortItems: sortItems,
      groupByCategory: groupByCategory,
      extraTabBuilder: extraTabBuilder,
      delegate: delegate,
      padding: padding,
      emptyContent: emptyContent,
      emptyText: emptyText,
    );
  }

  Widget _buildListItems(BuildContext context, T item, int index) {
    if (listItemBuilder != null) {
      return listItemBuilder!(context, item, index);
    }

    return FastListItemLayout(
      contentPadding: itemContentPadding,
      labelText: item.labelText,
      descriptionText: item.descriptionText,
      leading: item.descriptor?.leading,
      trailing: item.descriptor?.trailing,
      isEnabled: item.isEnabled,
      isDense: item.descriptor?.isDense ?? useDenseListItem,
    );
  }
}
