// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppNotificationPermissionBuilder extends StatelessWidget {
  final BlocBuilder<FastAppPermissionsBlocState> builder;

  const FastAppNotificationPermissionBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      buildWhen: (previous, next) {
        return previous.notificationPermission != next.notificationPermission;
      },
      bloc: FastAppPermissionsBloc.instance,
      builder: builder,
    );
  }
}
