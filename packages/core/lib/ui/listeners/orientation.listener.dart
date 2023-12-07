// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastDeviceOrientationListener extends StatefulWidget {
  final Widget child;

  const FastDeviceOrientationListener({super.key, required this.child});

  @override
  FastDeviceOrientationListenerState createState() =>
      FastDeviceOrientationListenerState();
}

class FastDeviceOrientationListenerState
    extends State<FastDeviceOrientationListener> with WidgetsBindingObserver {
  static final _bloc = FastDeviceOrientationBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final orientation = MediaQuery.orientationOf(context);
    _bloc.addEvent(FastDeviceOrientationBlocEvent.changed(orientation));
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
