// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

const _kAppBarHeightSize = Size.fromHeight(kToolbarHeight);

class FastNavigationSplitView extends StatefulWidget {
  final FastItemDetailsBuilder<FastItem> detailsBuilder;
  final FastListItemBuilder<FastItem>? listItemBuilder;
  final EdgeInsets? itemContentPadding;
  final String? searchPlaceholderText;
  final bool shouldUseFuzzySearch;
  final Widget? clearSearchIcon;
  final bool showItemDivider;
  final bool showSearchBar;
  final bool sortItems;
  final bool isEnabled;
  final List<FastItem> items;

  ///
  /// The padding for the page.
  ///
  final bool isTitlePositionBelowAppBar;

  ///
  /// A button displayed floating above body, in the bottom right corner.
  ///
  final Widget? floatingActionButton;

  ///
  /// The AppBar background color.
  ///
  final Color? appBarBackgroundColor;

  ///
  /// Indicates the size of the app bar.
  ///
  final Size appBarHeightSize;

  ///
  /// A list of Widgets to display in a row after the title.
  ///
  final List<Widget>? actions;

  ///
  /// The widget used to close the page.
  ///
  final Widget? closeButton;

  ///
  /// The widget used to go back to the previous page.
  ///
  final Widget? backButton;

  ///
  /// The title of the page.
  ///
  final String? titleText;

  ///
  /// Title's color.
  ///
  final Color? titleColor;

  ///
  /// A widget to display before the title.
  ///
  final Widget? leading;

  final bool showAppBar;

  const FastNavigationSplitView({
    super.key,
    required this.detailsBuilder,
    required this.items,
    this.searchPlaceholderText,
    this.clearSearchIcon,
    this.shouldUseFuzzySearch = false,
    this.showItemDivider = false,
    this.showSearchBar = false,
    this.sortItems = true,
    this.isEnabled = true,
    this.itemContentPadding,
    this.listItemBuilder,
    this.appBarHeightSize = _kAppBarHeightSize,
    this.isTitlePositionBelowAppBar = true,
    this.showAppBar = true,
    this.appBarBackgroundColor,
    this.floatingActionButton,
    this.closeButton,
    this.backButton,
    this.titleColor,
    this.titleText,
    this.actions,
    this.leading,
  });

  @override
  State<FastNavigationSplitView> createState() =>
      _FastNavigationSplitViewState();
}

class _FastNavigationSplitViewState extends State<FastNavigationSplitView> {
  late final FastNavigationSplitViewBloc _bloc;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late ValueNotifier<Locale> _userLocaleNotifier;
  bool _isInitialized = false;
  late Locale _userLocale;
  FastItem? _selection;

  @override
  void initState() {
    super.initState();
    _bloc = FastNavigationSplitViewBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _userLocale = Localizations.localeOf(context);
      _userLocaleNotifier = ValueNotifier(_userLocale);
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant FastNavigationSplitView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final locale = Localizations.localeOf(context);

    if (_userLocale != locale) {
      _userLocale = locale;
      _userLocaleNotifier.value = locale;
    }
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FastMediaLayoutBuilder(
        builder: ((BuildContext context, FastMediaType mediaType) {
          if (mediaType < FastMediaType.tablet) {
            return buildNavigationListView(context, mediaType);
          }

          return buildSplitView(context, mediaType);
        }),
      ),
    );
  }

  Widget buildNavigationListView(
    BuildContext context,
    FastMediaType mediaType,
  ) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: _selection == null ? '/' : '/details',
      onGenerateRoute: (settings) => _onGenerateRoute(settings, mediaType),
    );
  }

  Route _onGenerateRoute(
    RouteSettings settings,
    FastMediaType mediaType,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) {
        return ValueListenableBuilder(
          valueListenable: _userLocaleNotifier,
          builder: (context, locale, _) {
            late Widget page;

            switch (settings.name) {
              case '/':
                page = FastSectionPage(
                  isTitlePositionBelowAppBar: widget.isTitlePositionBelowAppBar,
                  appBarBackgroundColor: widget.appBarBackgroundColor,
                  floatingActionButton: widget.floatingActionButton,
                  appBarHeightSize: widget.appBarHeightSize,
                  closeButton: widget.closeButton,
                  showAppBar: widget.showAppBar,
                  backButton: widget.backButton,
                  titleColor: widget.titleColor,
                  titleText: widget.titleText,
                  actions: widget.actions,
                  leading: widget.leading,
                  contentPadding: EdgeInsets.zero,
                  child: Builder(
                    builder: (context) => buildListView(context, mediaType),
                  ),
                );
              case '/details':
                // TODO check for _selection
                page = FastSectionPage(
                  contentPadding: EdgeInsets.zero,
                  closeButton: widget.closeButton,
                  backButton: widget.backButton,
                  child: Builder(
                    builder: (context) {
                      return widget.detailsBuilder(context, _selection!);
                    },
                  ),
                );
            }

            return page;
          },
        );
      },
      settings: settings,
    );
  }

  Widget buildListView(
    BuildContext context,
    FastMediaType mediaType, {
    bool showTrailing = true,
  }) {
    return FastNavigationListView(
      searchPlaceholderText: widget.searchPlaceholderText,
      shouldUseFuzzySearch: widget.shouldUseFuzzySearch,
      itemContentPadding: widget.itemContentPadding,
      clearSearchIcon: widget.clearSearchIcon,
      showItemDivider: widget.showItemDivider,
      listItemBuilder: widget.listItemBuilder,
      showSearchBar: widget.showSearchBar,
      isEnabled: widget.isEnabled,
      sortItems: widget.sortItems,
      showTrailing: showTrailing,
      items: widget.items,
      onSelectionChanged: (value) => _onSelectionChanged(
        context,
        mediaType,
        value,
      ),
    );
  }

  Widget buildSplitView(BuildContext context, FastMediaType mediaType) {
    return FastScaffold(
      isTitlePositionBelowAppBar: widget.isTitlePositionBelowAppBar,
      appBarBackgroundColor: widget.appBarBackgroundColor,
      floatingActionButton: widget.floatingActionButton,
      appBarHeightSize: widget.appBarHeightSize,
      closeButton: widget.closeButton,
      showAppBar: widget.showAppBar,
      backButton: widget.backButton,
      titleColor: widget.titleColor,
      titleText: widget.titleText,
      actions: widget.actions,
      leading: widget.leading,
      child: SafeArea(
        top: false,
        bottom: false,
        child: FastSplitLayout(
          primaryBuilder: (context) {
            return _buildSplitPrimaryView(context, mediaType);
          },
          secondaryBuilder: _buildSplitSecondaryView,
        ),
      ),
    );
  }

  Widget _buildSplitPrimaryView(BuildContext context, FastMediaType mediaType) {
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
      onSelectionChanged: (value) => _onSelectionChanged(
        context,
        mediaType,
        value,
      ),
    );
  }

  Widget _buildSplitSecondaryView(BuildContext context) {
    return BlocBuilderWidget<FastNavigationSplitViewState>(
      bloc: _bloc,
      builder: (
        BuildContext context,
        FastNavigationSplitViewState state,
      ) {
        if (state.item != null) {
          return widget.detailsBuilder(context, state.item!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onSelectionChanged(
    BuildContext context,
    FastMediaType mediaType,
    FastItem item,
  ) {
    _selection = item;
    _bloc.addEvent(FastNavigationSplitViewBlocEvent.changed(item));

    if (mediaType < FastMediaType.tablet) {
      _navigateToDetails(context);
    }
  }

  void _navigateToDetails(BuildContext context) {
    Future.microtask(() {
      Navigator.pushNamed(context, '/details');
    });
  }
}
