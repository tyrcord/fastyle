// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';

// Project imports:
import 'package:fastyle_iap/fastyle_iap.dart';

mixin FastPremiumPlanMixin {
  List<FastAppFeatures> getFeaturesForPlan(String planId) {
    // default ones, should be app specific.
    return [FastAppFeatures.adFree];
  }

  void handleError(BuildContext context, FastPlanBloc bloc, dynamic error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showAnimatedFastAlertDialog(
        titleText: CoreLocaleKeys.core_label_error.tr(),
        validText: CoreLocaleKeys.core_label_ok.tr(),
        messageText: error.toString(),
        barrierDismissible: false,
        context: context,
        onValid: () {
          bloc.addEvent(const FastPlanBlocEvent.resetError());
          Navigator.pop(context);
        },
      );
    });
  }
}
