// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastStarRating extends StatefulWidget {
  final Function(double)? onRatingChanged;
  final double initialRating;
  final Color? filledColor;
  final Color? emptyColor;
  final int maxRating;
  final bool disabled;
  final bool readOnly;
  final double size;

  const FastStarRating({
    super.key,
    this.maxRating = 5,
    this.initialRating = 0,
    this.onRatingChanged,
    this.emptyColor,
    this.filledColor,
    this.size = kFastIconSizeSmall,
    this.disabled = false,
    this.readOnly = false,
  });

  @override
  FastStarRatingState createState() => FastStarRatingState();
}

class FastStarRatingState extends State<FastStarRating> {
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.maxRating,
        (index) => buildStar(context, index),
      ),
    );
  }

  Widget buildStar(BuildContext context, int index) {
    FaIcon icon;

    // Calculate the difference between the index and current rating.
    final double difference = _currentRating - index;

    if (difference >= 0.75) {
      icon = FaIcon(
        FontAwesomeIcons.solidStar,
        color: _getFilledColor(context),
        size: widget.size,
      );
    } else if (difference >= 0.25) {
      icon = FaIcon(
        FontAwesomeIcons.solidStarHalfStroke,
        color: _getFilledColor(context),
        size: widget.size,
      );
    } else {
      icon = buildStarIcon(context);
    }

    return GestureDetector(
      onTap: () {
        if (!widget.disabled && !widget.readOnly && mounted) {
          setState(() {
            _currentRating = index + 1;
            widget.onRatingChanged?.call(_currentRating);
          });
        }
      },
      child: icon,
    );
  }

  FaIcon buildStarIcon(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    IconData iconData = FontAwesomeIcons.star;

    if (useProIcons) {
      iconData = FastFontAwesomeIcons.lightStar;
    }

    return FaIcon(
      iconData,
      color: _getEmptyColor(context),
      size: widget.size,
    );
  }

  Color _getFilledColor(BuildContext context) {
    if (widget.filledColor != null) {
      return widget.filledColor!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.orange.mid;
  }

  Color _getEmptyColor(BuildContext context) {
    if (widget.emptyColor != null) {
      return widget.emptyColor!;
    }

    final palette = ThemeHelper.getPaletteColors(context);

    return palette.gray.lighter;
  }
}
