// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import 'package:fastyle_connectivity/logic/logic.dart';

class FastConnectivityStatusIcon extends StatelessWidget {
  final Widget? disconnectedIcon;
  final Color? disconnectedColor;
  final String disconnectedText;
  final Widget? connectedIcon;
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
    this.iconSize = kFastIconSizeXl,
    this.showDescription = false,
    this.hasConnection = false,
    this.isChecking = false,
    this.disconnectedColor,
    this.disconnectedIcon,
    this.connectedColor,
    this.description,
    this.connectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildIcon(context),
        if (showDescription) _buildDescription(context),
      ],
    );
  }

  Widget buildIcon(BuildContext context) {
    final icon = hasConnection
        ? buildConnectedIcon(context)
        : buildDisconnectedIcon(context);
    final color = isChecking
        ? _getCheckingColor(context)
        : hasConnection
            ? _getConnectedColor(context)
            : _getDisconnectedColor(context);

    if (icon is Icon) {
      return Icon(icon.icon, color: color, size: iconSize);
    } else if (icon is FaIcon) {
      return FaIcon(icon.icon, color: color, size: iconSize);
    }

    return icon;
  }

  Widget buildConnectedIcon(BuildContext context) {
    if (connectedIcon != null) {
      return connectedIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightWifi);
    }

    return const FaIcon(FontAwesomeIcons.wifi);
  }

  Widget buildDisconnectedIcon(BuildContext context) {
    if (disconnectedIcon != null) {
      return disconnectedIcon!;
    }

    final useProIcons = FastIconHelper.of(context).useProIcons;

    if (useProIcons) {
      return const FaIcon(FastFontAwesomeIcons.lightWifi);
    }

    return const FaIcon(FontAwesomeIcons.wifi);
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

  Color _getCheckingColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return connectedColor ?? palette.gray.mid;
  }

  Color _getConnectedColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return connectedColor ?? palette.green.mid;
  }

  Color _getDisconnectedColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return disconnectedColor ?? palette.red.mid;
  }
}
