import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:flutter/material.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

mixin FastPremiumPlanMixin {
  List<FastAppFeatures> getFeatureForPlan(String planId) {
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
