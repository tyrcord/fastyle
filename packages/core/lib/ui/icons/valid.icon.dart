// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastValidIcon extends StatelessWidget {
  final Color? color;
  final double size;

  const FastValidIcon({
    super.key,
    this.color,
    this.size = kFastIconSizeSmall,
  }) : assert(size >= 0);

  @override
  Widget build(BuildContext context) {
    final useProIcons = FastIconHelper.of(context).useProIcons;
    late IconData iconData;

    if (useProIcons) {
      iconData = FastFontAwesomeIcons.lightCircleCheck;
    } else {
      iconData = FontAwesomeIcons.circleCheck;
    }

    return FaIcon(iconData, size: size, color: color);
  }
}
