// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_firebase/fastyle_firebase.dart';

class FastFirebaseRemoteConfigBuilder extends StatelessWidget {
  final BlocBuilder<FastFirebaseRemoteConfigBlocState> builder;

  final bool Function(
    FastFirebaseRemoteConfigBlocState,
    FastFirebaseRemoteConfigBlocState,
  )? buildWhen;

  const FastFirebaseRemoteConfigBuilder({
    super.key,
    required this.builder,
    required this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilderWidget(
      bloc: FastFirebaseRemoteConfigBloc.instance,
      buildWhen: buildWhen,
      builder: builder,
    );
  }
}
