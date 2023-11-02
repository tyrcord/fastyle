import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matex_financial/financial.dart';
import 'package:matex_dart/matex_dart.dart';
import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

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
        late Widget icon;

        if (isInstrumentFavorite(baseMeta.code!, counterMeta.code!)) {
          icon = _getFilledHeartIcon(context);
        } else {
          icon = _getHollowHeartIcon(context);
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            icon,
            _getHeartIconHitZone(state),
          ],
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

  /// Returns a widget that displays a hollow heart icon.
  Widget _getHollowHeartIcon(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FaIcon(
      FastFontAwesomeIcons.lightHeart,
      size: kFastFontSize16,
      color: palette.gray.light,
    );
  }

  /// Returns a widget that displays a filled heart icon.
  Widget _getFilledHeartIcon(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return FaIcon(
      FontAwesomeIcons.solidHeart,
      size: kFastFontSize16,
      color: palette.red.mid,
    );
  }

  Widget _getHeartIconHitZone(MatexInstrumentFavoriteBlocState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: const SizedBox(width: 40, height: 40),
        onTap: () => _onIconTapped(state),
      ),
    );
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
