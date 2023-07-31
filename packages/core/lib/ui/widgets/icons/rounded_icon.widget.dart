// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastRoundedIcon extends StatelessWidget {
  final Color? backgroundColor;
  final FastBoxShape? shape;
  final Color? iconColor;
  final double? iconSize;
  final double ratio;
  final Widget icon;
  final double size;

  const FastRoundedIcon({
    super.key,
    required this.icon,
    this.size = kFastIconSizeMedium,
    this.ratio = 0.5,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final hasRadius = shape == FastBoxShape.roundedRectangle;
    final radius = hasRadius ? BorderRadius.circular(8) : null;
    final shape0 = _getShape();
    var icon0 = icon;

    if (icon is Icon) {
      icon0 = _transformIcon(icon as Icon);
    } else if (icon is FaIcon) {
      icon0 = _transformFaIcon(icon as FaIcon);
    }

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? ThemeHelper.colors.getPrimaryColor(context),
        borderRadius: radius,
        shape: shape0,
      ),
      child: Center(child: icon0),
    );
  }

  BoxShape _getShape() {
    switch (shape) {
      case FastBoxShape.roundedRectangle:
        return BoxShape.rectangle;
      case FastBoxShape.rectangle:
        return BoxShape.rectangle;
      default:
        return BoxShape.circle;
    }
  }

  Icon _transformIcon(Icon icon) {
    return Icon(
      icon.icon,
      color: iconColor ?? icon.color,
      size: iconSize ?? size * ratio,
    );
  }

  FaIcon _transformFaIcon(FaIcon icon) {
    return FaIcon(
      icon.icon,
      color: iconColor ?? icon.color,
      size: iconSize ?? size * ratio,
    );
  }
}
