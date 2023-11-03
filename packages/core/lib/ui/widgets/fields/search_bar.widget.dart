// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastSearchBar<T extends FastItem> extends StatefulWidget {
  final void Function(List<T>? suggestions, String? query)? onSuggestions;
  final bool Function(T option, String? query)? onSearchFilter;
  final TextEditingController? textEditingController;
  final VoidCallback? onLeadingButtonTap;
  final bool shouldUseFuzzySearch;
  final bool showShowBottomBorder;
  final String? placeholderText;
  final Widget? clearSearchIcon;
  final bool showLeadingIcon;
  final Widget? closeIcon;
  final Widget? backIcon;
  final List<T> items;

  const FastSearchBar({
    super.key,
    required this.items,
    this.placeholderText,
    this.clearSearchIcon,
    this.shouldUseFuzzySearch = false,
    this.showShowBottomBorder = true,
    this.closeIcon,
    this.backIcon,
    this.showLeadingIcon = true,
    this.textEditingController,
    this.onLeadingButtonTap,
    this.onSearchFilter,
    this.onSuggestions,
  });

  @override
  FastSearchBarState createState() => FastSearchBarState<T>();
}

class FastSearchBarState<T extends FastItem> extends State<FastSearchBar<T>> {
  late TextEditingController _textController;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _textController = widget.textEditingController ?? TextEditingController();
    _textController.addListener(_handleSearchQueryChanges);
  }

  @override
  void dispose() {
    super.dispose();

    _textController
      ..removeListener(_handleSearchQueryChanges)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) => _buildSearchAppBar(context);

  Widget _buildSearchAppBar(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: widget.showShowBottomBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: ThemeHelper.borderSize,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (widget.showLeadingIcon) _buildLeadingIcon(context),
          _buildSearchTextInput(context),
          _buildClearIcon(context),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    if (useCloseButton) {
      return FastCloseButton(onTap: widget.onLeadingButtonTap);
    }

    return FastBackButton(onTap: widget.onLeadingButtonTap);
  }

  Widget _buildSearchTextInput(BuildContext context) {
    return Expanded(
      child: FastSearchField(
        margin: widget.showLeadingIcon
            ? EdgeInsets.zero
            : const EdgeInsets.only(left: 16.0),
        placeholderText: widget.placeholderText,
        textEditingController: _textController,
      ),
    );
  }

  Widget _buildClearIcon(BuildContext context) {
    final theme = Theme.of(context);

    return FastIconButton(
      iconColor: _searchQuery == null ? theme.hintColor : null,
      onTap: () => _textController.clear(),
      iconSize: kFastIconSizeMedium,
      icon: buildClearIcon(context),
    );
  }

  Widget buildClearIcon(BuildContext context) {
    if (widget.clearSearchIcon != null) {
      return widget.clearSearchIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightEraser);
    }

    return const FaIcon(FontAwesomeIcons.eraser);
  }

  void _handleSearchQueryChanges() {
    if (!mounted) return;

    final queryText = _textController.text;

    if (queryText != _searchQuery && widget.onSuggestions != null) {
      setState(() {
        if (queryText.isEmpty) {
          _searchQuery = null;
          widget.onSuggestions!(null, null);
        } else {
          _searchQuery = removeDiacriticsAndLowercase(queryText);
          widget.onSuggestions!(_buildSuggestions(_searchQuery), _searchQuery);
        }
      });
    }
  }

  List<T> _buildSuggestions(String? queryText) {
    if (widget.shouldUseFuzzySearch) {
      return _buildFuzzySuggestions(queryText!);
    }

    return widget.items.where((T option) {
      if (widget.onSearchFilter != null) {
        return widget.onSearchFilter!(option, queryText);
      }

      return removeDiacriticsAndLowercase(option.labelText)
              .contains(queryText!) ||
          (option.descriptionText != null
              ? removeDiacriticsAndLowercase(option.descriptionText!)
                  .contains(queryText)
              : false);
    }).toList();
  }

  List<T> _buildFuzzySuggestions(String queryText) {
    final fuse = Fuzzy(widget.items, options: kFastFastItemFuzzyOptions);
    final results = <T>[];

    // TODO: workaround https://github.com/comigor/fuzzy/issues/8
    final rawResults = fuse.search(queryText);
    for (final r in rawResults) {
      r.score = r.matches[0].score;
    }
    rawResults.sort((a, b) => a.score.compareTo(b.score));

    for (final result in rawResults) {
      results.add(result.item as T);
    }

    return results;
  }
}
