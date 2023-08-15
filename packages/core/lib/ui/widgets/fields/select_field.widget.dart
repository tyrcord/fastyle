// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSelectField<T> extends StatefulWidget {
  /// A function that creates additional tab views.
  final List<FastListItemCategory<FastItem<T>>> Function()? extraTabBuilder;

  /// The delegate object that can modify the behavior of the widget.
  final FastListViewLayoutDelegate<FastItem<T>>? searchPageDelegate;

  final ValueChanged<FastItem<T>?> onSelectionChanged;
  final List<FastCategory>? categories;
  final String searchPlaceholderText;
  final String clearSelectionText;
  final bool showHelperBoundaries;
  final String? placeholderText;
  final List<FastItem<T>> items;
  final int intialCategoryIndex;
  final String? allCategoryText;
  final FastItem<T>? selection;
  final Widget? clearSearchIcon;
  final bool canClearSelection;
  final String searchTitleText;
  final bool groupByCategory;
  final bool useFuzzySearch;
  final String? captionText;
  final String? helperText;
  final String labelText;
  final Widget? closeIcon;
  final Widget? backIcon;
  final bool isReadOnly;
  final bool isEnabled;
  final bool sortItems;
  final Widget? listViewEmptyContent;
  final String? listViewEmptyText;
  final VoidCallback? onSearchPageClose;
  final FastFastSelectFieldDelegate<FastItem<T>>? delegate;
  final Widget? icon;
  final Widget? leading;

  const FastSelectField({
    super.key,
    required this.onSelectionChanged,
    required this.labelText,
    required this.items,
    this.searchPlaceholderText = kFastSearchPlaceholderText,
    this.clearSelectionText = kFastClearSelectionText,
    this.clearSearchIcon,
    this.searchTitleText = kFastSelectTitleText,
    this.showHelperBoundaries = true,
    this.canClearSelection = true,
    this.intialCategoryIndex = 0,
    this.groupByCategory = false,
    this.useFuzzySearch = false,
    this.isReadOnly = false,
    this.sortItems = true,
    this.isEnabled = true,
    this.placeholderText,
    this.allCategoryText,
    this.extraTabBuilder,
    this.captionText,
    this.helperText,
    this.categories,
    this.closeIcon,
    this.backIcon,
    this.searchPageDelegate,
    this.selection,
    this.listViewEmptyContent,
    this.listViewEmptyText,
    this.onSearchPageClose,
    this.delegate,
    this.icon,
    this.leading,
  });

  @override
  State<StatefulWidget> createState() => _FastSelectFieldState<T>();
}

class _FastSelectFieldState<T> extends State<FastSelectField<T>> {
  late FocusNode _focusNode;
  FastItem<T>? _selection;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _selection = widget.selection;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FastSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selection != oldWidget.selection) {
      setState(() => _selection = widget.selection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleOnTap,
      child: FastFieldLayout(
        showHelperBoundaries: widget.showHelperBoundaries,
        captionText: widget.captionText,
        control: buildControl(context),
        helperText: widget.helperText,
        labelText: widget.labelText,
      ),
    );
  }

  Widget buildControl(BuildContext context) {
    return DecoratedBox(
      decoration: buildBorderSide(context),
      child: Row(
        children: <Widget>[
          if (widget.leading != null) buildLeading(context),
          Expanded(child: buildLabel(context)),
          buildIcon(context),
        ],
      ),
    );
  }

  Widget buildLeading(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.tightFor(width: kFastIconSizeSmall),
      margin: const EdgeInsets.only(right: 8),
      child: widget.leading,
    );
  }

  Widget buildLabel(BuildContext context) {
    if (_selection != null) {
      return FastBody(
        textColor: _getLabelColor(context),
        fontWeight: kFastFontWeightBold,
        text: _selection!.labelText,
      );
    } else if (widget.placeholderText != null) {
      return FastPlaceholder(
        textColor: _getPlaceholderColor(context),
        fontWeight: kFastFontWeightBold,
        text: widget.placeholderText!,
      );
    }

    return FastBody(
      textColor: _getLabelColor(context),
      fontWeight: kFastFontWeightBold,
      text: kFastNoneString,
    );
  }

  Widget buildIcon(BuildContext context) {
    if (widget.icon != null) {
      return widget.icon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return FaIcon(
        FastFontAwesomeIcons.lightChevronDown,
        color: _getLabelColor(context),
        size: kFastIconSizeXs,
      );
    }

    return FaIcon(
      FontAwesomeIcons.chevronDown,
      color: _getLabelColor(context),
      size: kFastIconSizeXs,
    );
  }

  BoxDecoration buildBorderSide(BuildContext context) {
    Color? color;

    if (!widget.isEnabled) {
      color = ThemeHelper.colors.getDisabledColor(context);
    }

    return ThemeHelper.createBorderSide(context, color: color);
  }

  Future<void> handleOnTap() async {
    final items = widget.items;

    if (widget.isEnabled && !widget.isReadOnly && items.isNotEmpty) {
      FocusManager.instance.primaryFocus!.unfocus();
      _focusNode.requestFocus();

      int categoryIndex = widget.intialCategoryIndex;

      if (widget.delegate != null) {
        categoryIndex = widget.delegate!.willUseCategoryIndex(
          widget,
          categoryIndex,
        );
      }

      final response = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => FastSearchPage<FastItem<T>>(
            searchPlaceholderText: widget.searchPlaceholderText,
            listViewEmptyContent: widget.listViewEmptyContent,
            clearSelectionText: widget.clearSelectionText,
            canClearSelection: widget.canClearSelection,
            listViewEmptyText: widget.listViewEmptyText,
            allCategoryText: widget.allCategoryText,
            clearSearchIcon: widget.clearSearchIcon,
            groupByCategory: widget.groupByCategory,
            extraTabBuilder: widget.extraTabBuilder,
            useFuzzySearch: widget.useFuzzySearch,
            delegate: widget.searchPageDelegate,
            intialCategoryIndex: categoryIndex,
            titleText: widget.searchTitleText,
            categories: widget.categories,
            sortItems: widget.sortItems,
            selection: widget.selection,
            closeIcon: widget.closeIcon,
            backIcon: widget.backIcon,
            items: widget.items,
          ),
          fullscreenDialog: true,
        ),
      ) as FastItem<T>?;

      setState(() {
        _selection = response;
        widget.onSelectionChanged(_selection);
      });

      widget.onSearchPageClose?.call();
    }
  }

  // private methods

  /// Returns the label color based on the current state of the field.
  Color _getLabelColor(BuildContext context) {
    Color? color;

    if (!widget.isEnabled) {
      color = ThemeHelper.colors.getDisabledColor(context);
    }

    return color ?? ThemeHelper.texts.getBodyTextStyle(context).color!;
  }

  /// Returns the placeholder color based on the current state of the field.
  Color _getPlaceholderColor(BuildContext context) {
    Color? color;

    if (!widget.isEnabled) {
      color = ThemeHelper.colors.getDisabledColor(context);
    }

    return color ?? ThemeHelper.texts.getPlaceholderTextStyle(context).color!;
  }
}
