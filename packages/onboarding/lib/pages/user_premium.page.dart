// Flutter imports:
import 'dart:async';

import 'package:fastyle_iap/fastyle_iap.dart';
import 'package:fastyle_onboarding/fastyle_onboarding.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:lingua_onboarding/generated/locale_keys.g.dart';
import 'package:tbloc/tbloc.dart';

/// A page that displays a layout with an icon, a primary text, a secondary text
/// and a list of children widgets.
class FastOnboardingPremiumUser extends StatefulWidget {
  /// The controller to use to pause and resume the onboarding.
  final FastOnboardingViewController? controller;

  /// The title text to display.
  final String? titleText;

  /// The palette to use for the icon.
  final FastPaletteScheme? palette;

  /// A list of widgets to display below the primary and secondary texts.
  final List<Widget>? children;

  /// The text to display below the icon.
  final String? primaryText;

  /// The text to display below the primary text.
  final String? secondaryText;

  /// The size of the icon to display on a handset.
  final double? handsetIconSize;

  /// The size of the icon to display on a tablet.
  final double? tabletIconSize;

  /// The callback to call when the action is tapped.
  final VoidCallback? onActionTap;

  /// The text to display as an action.
  final String? actionText;

  /// The icon to display at the top of the layout.
  final Widget? icon;

  final String? notesText;

  final String? premiumProductId;

  const FastOnboardingPremiumUser({
    super.key,
    this.premiumProductId,
    this.handsetIconSize,
    this.tabletIconSize,
    this.secondaryText,
    this.primaryText,
    this.onActionTap,
    this.controller,
    this.actionText,
    this.titleText,
    this.children,
    this.palette,
    this.notesText,
    this.icon,
  });

  @override
  State<FastOnboardingPremiumUser> createState() =>
      _FastOnboardingPremiumUserState();
}

class _FastOnboardingPremiumUserState extends State<FastOnboardingPremiumUser>
    with FastPremiumPlanMixin {
  late StreamSubscription<FastPlanBlocState> errorSubscription;
  late final FastPlanBloc planBloc;
  final _storeBloc = FastStoreBloc();

  @override
  void initState() {
    super.initState();

    planBloc = FastPlanBloc(getFeaturesForPlan: getFeatureForPlan);
    errorSubscription = planBloc.onData
        .where((state) => state.error != null)
        .listen((state) => handleError(context, planBloc, state.error));
  }

  @override
  void dispose() {
    super.dispose();
    planBloc.close();
    errorSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: planBloc,
      child: FastOnboardingPage(
        titleText: _getTitleText(),
        children: [buildContent(context)],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return BlocBuilderWidget(
      bloc: _storeBloc,
      buildWhen: (_, next) {
        return next.hasPurchasedProduct(_getPremiumProductId());
      },
      builder: (context, state) {
        if (state.hasPurchasedProduct(_getPremiumProductId())) {
          return FastOnboardingThanksPremiumContent(
            handsetIconSize: widget.handsetIconSize,
            tabletIconSize: widget.tabletIconSize,
            secondaryText: widget.secondaryText,
            primaryText: widget.primaryText,
            notesText: widget.notesText,
            palette: widget.palette,
            icon: widget.icon,
            children: widget.children,
          );
        }

        return FastOnboardingRestorePremiumContent(
          handsetIconSize: widget.handsetIconSize,
          tabletIconSize: widget.tabletIconSize,
          secondaryText: widget.secondaryText,
          primaryText: widget.primaryText,
          notesText: widget.notesText,
          palette: widget.palette,
          icon: widget.icon,
          children: widget.children,
        );
      },
    );
  }

  String _getTitleText() {
    return widget.titleText ??
        OnboardingLocaleKeys.onboarding_restore_premium_title.tr();
  }

  String _getPremiumProductId() {
    String? id = widget.premiumProductId;
    id ??= getPremiumProductId();

    assert(id != null, 'The premium product id must not be null');

    return id!;
  }
}
