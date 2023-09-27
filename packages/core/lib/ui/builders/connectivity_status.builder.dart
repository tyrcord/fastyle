// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:tbloc/tbloc.dart';

class FastConnectivityStatusBuilder extends StatelessWidget {
  final WidgetBuilder? disconnectedBuilder;
  final WidgetBuilder? connectedBuilder;

  const FastConnectivityStatusBuilder({
    super.key,
    this.connectedBuilder,
    this.disconnectedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastConnectivityStatusBloc.instance,
      builder: (context, state) {
        if (state.isConnected) {
          return Builder(builder: connectedBuilder ?? buildEmptyContainer);
        }

        return Builder(builder: disconnectedBuilder ?? buildEmptyContainer);
      },
    );
  }

  Widget buildEmptyContainer(BuildContext context) {
    return const SizedBox();
  }
}
