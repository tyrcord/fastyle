// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_connectivity/fastyle_connectivity.dart';

class FastConnectivityStatusListener extends StatefulWidget {
  final IconData? disconnectedIcon;
  final Color? disconnectedColor;
  final String disconnectedText;
  final Duration? checkInterval;
  final Duration? checkTimeout;
  final IconData connectedIcon;
  final Color? connectedColor;
  final bool showDescription;
  final String connectedText;
  final String? checkAddress;
  final Widget? description;
  final double iconSize;
  final int? checkPort;

  const FastConnectivityStatusListener({
    super.key,
    this.disconnectedText = kFastConnectivityDisconnectedText,
    this.connectedText = kFastConnectivityConnectedText,
    this.connectedIcon = FontAwesomeIcons.wifi,
    this.iconSize = kFastIconSizeXl,
    this.showDescription = false,
    this.disconnectedColor,
    this.disconnectedIcon,
    this.connectedColor,
    this.checkInterval,
    this.checkTimeout,
    this.checkAddress,
    this.description,
    this.checkPort,
  });

  @override
  FastConnectivityStatusListenerState createState() =>
      FastConnectivityStatusListenerState();
}

class FastConnectivityStatusListenerState
    extends State<FastConnectivityStatusListener> {
  late FastConnectivityStatusBloc _connectivityStatusBloc;

  @override
  void initState() {
    super.initState();
    _connectivityStatusBloc = FastConnectivityStatusBloc();

    final event = FastConnectivityStatusBlocEvent.init(
      payload: FastConnectivityStatusBlocEventPayload(
        checkInterval: widget.checkInterval,
        checkTimeout: widget.checkTimeout,
        checkAddress: widget.checkAddress,
        checkPort: widget.checkPort,
      ),
    );

    _connectivityStatusBloc.addEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _connectivityStatusBloc,
      child: BlocBuilderWidget(
        bloc: _connectivityStatusBloc,
        builder: (_, state) {
          return FastConnectivityStatusIcon(
            isChecking: state.isInitializing || !state.isInitialized,
            disconnectedColor: widget.disconnectedColor,
            disconnectedIcon: widget.disconnectedIcon,
            disconnectedText: widget.disconnectedText,
            showDescription: widget.showDescription,
            connectedColor: widget.connectedColor,
            connectedText: widget.connectedText,
            connectedIcon: widget.connectedIcon,
            hasConnection: state.hasConnection,
            description: widget.description,
            iconSize: widget.iconSize,
          );
        },
      ),
    );
  }
}
