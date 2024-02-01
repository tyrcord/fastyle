// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:matex_financial/financial.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_financial/fastyle_financial.dart';

/// A widget that displays a heart icon indicating whether a currency
/// is marked as favorite or not. The widget is built using the
/// `BlocBuilderWidget` class from the `tbloc` package.
class FastCurrencyFavoriteIcon extends StatelessWidget {
  /// The `CurrencyFavoriteBloc` instance used to manage the state of the
  /// favorite currencies.
  final MatexCurrencyFavoriteBloc favoriteBloc;

  /// The currency code to be checked for favorite status.
  final String currencyCode;

  /// Creates a new instance of `FastCurrencyFavoriteIcon`.
  const FastCurrencyFavoriteIcon({
    super.key,
    required this.favoriteBloc,
    required this.currencyCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: favoriteBloc,
      buildWhen: (previous, next) => _shouldRebuildIcon(previous, next),
      builder: (context, state) {
        return FastItemFavoriteIcon(
          onIconTapped: () => _onIconTapped(state),
          isFavorite: isCurrencyFavorite(
            currencyCode,
            favorites: state.favorites,
          ),
        );
      },
    );
  }

  /// Determines whether the heart icon should be rebuilt or not based on
  /// changes in the `favoriteBloc` state.
  bool _shouldRebuildIcon(
    MatexCurrencyFavoriteBlocState previous,
    MatexCurrencyFavoriteBlocState next,
  ) {
    final prevIsFavorite =
        isCurrencyFavorite(currencyCode, favorites: previous.favorites);
    final nextIsFavorite =
        isCurrencyFavorite(currencyCode, favorites: next.favorites);

    return nextIsFavorite != prevIsFavorite;
  }

  /// Handles the tap event on the heart icon. Adds or removes the currency
  /// from the list of favorite currencies in the `favoriteBloc` depending on
  /// its current state.
  void _onIconTapped(MatexCurrencyFavoriteBlocState state) {
    final isFavorite =
        isCurrencyFavorite(currencyCode, favorites: state.favorites);

    if (!isFavorite) {
      favoriteBloc.addEvent(MatexCurrencyFavoriteBlocEvent.add(currencyCode));
    } else {
      favoriteBloc.addEvent(
        MatexCurrencyFavoriteBlocEvent.remove(currencyCode),
      );
    }
  }
}
