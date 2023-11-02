import 'package:collection/collection.dart' show IterableExtension;
import 'package:fastyle_core/fastyle_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_financial/fastyle_financial.dart';
import 'package:fastyle_images/fastyle_images.dart';
import 'package:flutter/material.dart';
import 'package:matex_dart/matex_dart.dart'
    show MatexPairMetadata, MatexInstrumentMetadata;
import 'package:matex_financial/financial.dart';
import 'package:tbloc/tbloc.dart';
import 'package:lingua_finance/generated/locale_keys.g.dart';
import 'package:lingua_finance_instrument/generated/locale_keys.g.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:lingua_core/lingua_core.dart';
import 'package:lingua_finance_instrument/lingua_finance_instrument.dart';

const _kLeadingWidth = 40.0;
const _kLeadingHeight = 32.0;
// const _kImageMultiplicator = 0.75;
const _kFavoritesTabValue = 'favorites';

typedef FastFinancialInstrumentItem = FastItem<MatexFinancialInstrument>;

class FastSelectInstrumentField extends StatefulWidget {
  /// A callback function that builds the flag icon for each item.
  final Widget Function(String)? flagIconBuilder;

  final ValueChanged<FastItem<MatexFinancialInstrument>?> onSelectionChanged;
  final MatexFinancialInstrument? selection;
  final String? captionText;
  final bool isEnabled;

  const FastSelectInstrumentField({
    super.key,
    required this.onSelectionChanged,
    this.selection,
    this.captionText,
    this.isEnabled = true,
    this.flagIconBuilder,
  });

  @override
  FastSelectInstrumentFieldState createState() =>
      FastSelectInstrumentFieldState();
}

class FastSelectInstrumentFieldState extends State<FastSelectInstrumentField>
    implements
        FastFastSelectFieldDelegate<FastItem<MatexFinancialInstrument>>,
        FastListViewLayoutDelegate<FastItem<MatexFinancialInstrument>> {
  final _currencyPairBloc = MatexFinancialInstrumentsBloc();
  final _favoriteBloc = MatexInstrumentFavoriteBloc();

  late List<FastItem<MatexFinancialInstrument>> _items;
  FastItem<MatexFinancialInstrument>? _selection;

  String get searchPlaceholderText {
    const k = FinanceInstrumentLocaleKeys.instrument_message_search_instrument;

    return k.tr();
  }

  String get searchTitleText {
    return FinanceInstrumentLocaleKeys.instrument_select_instrument.tr();
  }

  String get maleGender => LinguaLocalizationGender.male;

  @override
  void initState() {
    super.initState();

    // _imageWidth = _kLeadingWidth * _kImageMultiplicator;
    // _imageHeight = _kLeadingHeight * _kImageMultiplicator;

    // FIXME: listen to possible changes
    _items = _buildItems(_currencyPairBloc.currentState.instruments);
    _findSelection();
  }

  @override
  void didUpdateWidget(FastSelectInstrumentField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selection != widget.selection) {
      setState(() => _selection = _findSelection());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastSelectField<MatexFinancialInstrument>(
      allCategoryText: CoreLocaleKeys.core_label_all.tr(gender: maleGender),
      labelText: FinanceLocaleKeys.finance_label_financial_instrument.tr(),
      listViewEmptyContent: const Center(child: FastNoFavoriteIcon()),
      extraTabBuilder: () => [_buildFavoritesTab()],
      onSelectionChanged: widget.onSelectionChanged,
      searchPlaceholderText: searchPlaceholderText,
      listViewContentPadding: EdgeInsets.zero,
      searchTitleText: searchTitleText,
      captionText: widget.captionText,
      isReadOnly: !widget.isEnabled,
      noneTextGender: maleGender,
      searchPageDelegate: this,
      selection: _selection,
      groupByCategory: true,
      useFuzzySearch: true,
      delegate: this,
      items: _items,
    );
  }

  FastListItemCategory<FastFinancialInstrumentItem> _buildFavoritesTab() {
    return FastListItemCategory(
      labelText: CoreLocaleKeys.core_label_favorites.tr(),
      items: findFavoriteInstuments(_items),
      valueText: _kFavoritesTabValue,
      weight: 999,
    );
  }

  List<FastFinancialInstrumentItem> _buildItems(
    List<MatexPairMetadata> instrumentsMetadata,
  ) {
    return instrumentsMetadata.where((element) {
      return element.counterInstrumentMetadata != null &&
          element.baseInstrumentMetadata != null;
    }).map((MatexPairMetadata pair) {
      final counterMeta = pair.counterInstrumentMetadata;
      final baseMeta = pair.baseInstrumentMetadata;
      final hasExtraMeta = baseMeta != null && counterMeta != null;
      final value = MatexFinancialInstrument(
        baseCode: pair.baseCode,
        counterCode: pair.counterCode,
      );

      if (hasExtraMeta && baseMeta.type.main == 'index') {
        return FastItem(
          descriptor: FastListItemDescriptor(
            padding: const EdgeInsets.only(right: 16),
            leading: _buildLeadingLayout(
              counterMeta: counterMeta,
              baseMeta: baseMeta,
              child: _buildFlagIcon(baseMeta)!,
            ),
          ),
          labelText: baseMeta.name!.localized,
          descriptionText: baseMeta.symbol?.ticker ?? baseMeta.code,
          categories: [_buildFastCategoryForPair(pair)],
          value: value,
        );
      }

      return FastItem(
        descriptor: hasExtraMeta
            ? _buildInstrumentPairLeading(baseMeta, counterMeta)
            : null,
        labelText: '${pair.baseCode}/${pair.counterCode}',
        descriptionText: hasExtraMeta
            ? _buildPairDescriptionText(baseMeta, counterMeta)
            : null,
        categories: [_buildFastCategoryForPair(pair)],
        value: value,
      );
    }).toList();
  }

  FastItem<MatexFinancialInstrument>? _findSelection() {
    return _items.firstWhereOrNull((item) => item.value == widget.selection);
  }

  FastCategory _buildFastCategoryForPair(MatexPairMetadata pair) {
    return FastCategory(
      labelText: getLabelTextForInstrumentType(pair.type.key),
      valueText: pair.type.main,
      weight: pair.type.weight,
    );
  }

  Widget _buildLeadingLayout({
    required Widget child,
    required MatexInstrumentMetadata baseMeta,
    required MatexInstrumentMetadata counterMeta,
  }) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FastMatexInstrumentFavoriteIcon(
          baseMeta: baseMeta,
          counterMeta: counterMeta,
          favoriteBloc: _favoriteBloc,
        ),
        child,
      ],
    );
  }

  FastListItemDescriptor _buildInstrumentPairLeading(
    MatexInstrumentMetadata baseMeta,
    MatexInstrumentMetadata counterMeta,
  ) {
    return FastListItemDescriptor(
      padding: const EdgeInsets.only(right: 16),
      leading: _buildLeadingLayout(
        counterMeta: counterMeta,
        baseMeta: baseMeta,
        child: SizedBox(
          height: _kLeadingHeight,
          width: _kLeadingWidth,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: buildFlagIconForCountry(counterMeta.icon!),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: buildFlagIconForCountry(baseMeta.icon!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildPairDescriptionText(
    MatexInstrumentMetadata baseMeta,
    MatexInstrumentMetadata counterMeta,
  ) {
    final baseLabel = buildLocaleCurrencyKey(baseMeta.name!.key).tr();
    final counterLabel = buildLocaleCurrencyKey(counterMeta.name!.key).tr();

    return '$baseLabel / $counterLabel';
  }

  @override
  Widget? willBuildListViewForCategory(
    FastListViewLayout<FastItem> listViewLayout,
    FastListItemCategory<FastItem<MatexFinancialInstrument>> category,
  ) {
    if (category.valueText == _kFavoritesTabValue) {
      return BlocBuilderWidget(
        bloc: _favoriteBloc,
        builder: (context, state) {
          return listViewLayout.buildListView(
            context,
            findFavoriteInstuments(_items),
          );
        },
      );
    }

    return null;
  }

  @override
  int willUseCategoryIndex(
    FastSelectField selectField,
    int categoryCategoryIndex,
  ) {
    return _favoriteBloc.hasFavorites ? 1 : 2;
  }

  Widget? _buildFlagIcon(
    MatexInstrumentMetadata instrument, {
    bool hasShadow = true,
    double width = 20,
    double? height,
  }) {
    return buildFlagIconForCountry(
      instrument.icon!,
      hasShadow: hasShadow,
      height: height,
      width: width,
    );
  }
}
