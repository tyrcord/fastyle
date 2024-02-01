// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:matex_financial/financial.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_financial/fastyle_financial.dart';

/// A widget that displays a heart icon indicating whether a financial
/// instrument is marked as favorite or not. The widget is built using the
/// `BlocBuilderWidget` class from the `tbloc` package.
class FastMatexInstrumentFavoriteIcon extends StatelessWidget {
  /// The `MatexInstrumentFavoriteBloc` instance used to manage the state of the
  /// favorite instruments.
  final MatexInstrumentFavoriteBloc favoriteBloc;

  /// An instance of `MatexInstrumentMetadata` that represents the metadata of
  /// the counter currency of the instrument.
  final MatexInstrumentMetadata counterMeta;

  /// An instance of `MatexInstrumentMetadata` that represents the metadata of
  /// the base currency of the instrument.
  final MatexInstrumentMetadata baseMeta;

  /// Creates a new instance of `MatexInstrumentFavoriteIcon`.
  const FastMatexInstrumentFavoriteIcon({
    super.key,
    required this.favoriteBloc,
    required this.counterMeta,
    required this.baseMeta,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: favoriteBloc,
      buildWhen: (previous, next) => _shouldRebuildIcon(previous, next),
      builder: (context, state) {
        return FastItemFavoriteIcon(
          onIconTapped: () => _onIconTapped(state),
          isFavorite: isInstrumentFavorite(
            baseMeta.code!,
            counterMeta.code!,
            favorites: state.favorites,
          ),
        );
      },
    );
  }

  /// Determines whether the heart icon should be rebuilt or not based on
  /// changes in the `favoriteBloc` state.
  bool _shouldRebuildIcon(
    MatexInstrumentFavoriteBlocState previous,
    MatexInstrumentFavoriteBlocState next,
  ) {
    final base = baseMeta.code!;
    final counter = counterMeta.code!;
    final prevFav = previous.favorites;
    final nextFav = next.favorites;
    final previousIsFavorite =
        isInstrumentFavorite(base, counter, favorites: prevFav);
    final nextIsFavorite =
        isInstrumentFavorite(base, counter, favorites: nextFav);

    return nextIsFavorite != previousIsFavorite;
  }

  /// Handles the tap event on the heart icon. Adds or removes the instrument
  /// from the list of favorite instruments in the `favoriteBloc` depending on
  /// its current state.
  void _onIconTapped(MatexInstrumentFavoriteBlocState state) {
    final isFavorite = isInstrumentFavorite(baseMeta.code!, counterMeta.code!);

    if (!isFavorite) {
      favoriteBloc.addEvent(
        MatexInstrumentFavoriteBlocEvent.add(
          MatexInstrumentFavorite(
            base: baseMeta.code!,
            counter: counterMeta.code!,
          ),
        ),
      );
    } else {
      favoriteBloc.addEvent(
        MatexInstrumentFavoriteBlocEvent.remove(
          MatexInstrumentFavorite(
            base: baseMeta.code!,
            counter: counterMeta.code!,
          ),
        ),
      );
    }
  }
}
