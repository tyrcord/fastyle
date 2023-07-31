// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastThemeSpacingHelper {
  EdgeInsets getPadding(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return kFastEdgeInsets24;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return kFastEdgeInsets32;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return kFastEdgeInsets40;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return kFastEdgeInsets48;
    }

    return kFastEdgeInsets16;
  }

  EdgeInsets getHorizontalPadding(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return kFastHorizontalEdgeInsets24;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return kFastHorizontalEdgeInsets32;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return kFastHorizontalEdgeInsets40;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return kFastHorizontalEdgeInsets48;
    }

    return kFastHorizontalEdgeInsets16;
  }

  EdgeInsets getVerticalPadding(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return kFastVerticalEdgeInsets24;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return kFastVerticalEdgeInsets32;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return kFastVerticalEdgeInsets40;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return kFastVerticalEdgeInsets48;
    }

    return kFastVerticalEdgeInsets16;
  }

  double getSpacing(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return FastSpacing.small;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return FastSpacing.medium;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return FastSpacing.large;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return FastSpacing.xl;
    }

    return FastSpacing.xs;
  }

  SizedBox getVerticalSpacing(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return kFastVerticalSizedBox24;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return kFastVerticalSizedBox32;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return kFastVerticalSizedBox40;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return kFastVerticalSizedBox48;
    }

    return kFastVerticalSizedBox16;
  }

  SizedBox getHorizontalSpacing(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    if (size.width >= FastMediaBreakpoints.tablet) {
      return kFastHorizontalSizedBox24;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return kFastHorizontalSizedBox32;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return kFastHorizontalSizedBox40;
    } else if (size.width >= FastMediaBreakpoints.xl) {
      return kFastHorizontalSizedBox48;
    }

    return kFastHorizontalSizedBox16;
  }
}
