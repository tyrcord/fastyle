// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_connectivity/logic/logic.dart';

class FastConnectivityStatusIcon extends StatelessWidget {
  final IconData? disconnectedIcon;
  final Color? disconnectedColor;
  final String disconnectedText;
  final IconData connectedIcon;
  final Color? connectedColor;
  final bool showDescription;
  final String connectedText;
  final String checkingText;
  final Widget? description;
  final bool hasConnection;
  final double iconSize;
  final bool isChecking;

  const FastConnectivityStatusIcon({
    super.key,
    this.disconnectedText = kFastConnectivityDisconnectedText,
    this.connectedText = kFastConnectivityConnectedText,
    this.checkingText = kFastConnectivityCheckingText,
    this.connectedIcon = FontAwesomeIcons.wifi,
    this.iconSize = kFastIconSizeXl,
    this.showDescription = false,
    this.hasConnection = false,
    this.isChecking = false,
    this.disconnectedColor,
    this.disconnectedIcon,
    this.connectedColor,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIcon(context),
        if (showDescription) _buildDescription(context),
      ],
    );
  }

  Widget _buildIcon(BuildContext context) {
    final icon =
        hasConnection ? connectedIcon : disconnectedIcon ?? connectedIcon;
    final color = isChecking
        ? getCheckingColor(context)
        : hasConnection
            ? getConnectedColor(context)
            : getDisconnectedColor(context);

    return FaIcon(icon, color: color, size: iconSize);
  }

  Widget _buildDescription(BuildContext context) {
    final padding = ThemeHelper.spacing.getSpacing(context);

    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: description ?? buildDefaultDescription(),
    );
  }

  Widget buildDefaultDescription() {
    return FastBody(
      text: isChecking
          ? checkingText
          : hasConnection
              ? connectedText
              : disconnectedText,
    );
  }

  Color getCheckingColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return connectedColor ?? palette.gray.mid;
  }

  Color getConnectedColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return connectedColor ?? palette.green.mid;
  }

  Color getDisconnectedColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return disconnectedColor ?? palette.red.mid;
  }
}
