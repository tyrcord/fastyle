// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastThreeBounceIndicator extends StatelessWidget {
  final Color? color;

  const FastThreeBounceIndicator({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: color ?? ThemeHelper.colors.getPrimaryColor(context),
        size: kFastIconSizeSmall,
      ),
    );
  }
}
