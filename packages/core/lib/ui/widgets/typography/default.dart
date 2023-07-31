// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// DISPLAY 1
/// 48px
/// regular
/// lowercase
class FastDisplay extends FastBaseTypography {
  const FastDisplay({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
    super.upperCase,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getDisplayTextStyle(context);
  }
}

/// HEADLINE
/// 34px
/// medium
/// lowercase
class FastHeadline extends FastBaseTypography {
  const FastHeadline({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
    super.upperCase,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getHeadlineTextStyle(context);
  }
}

/// PLACEHOLDER HEADLINE
/// 34px
/// light
/// lowercase
class FastPlaceHolderHeadline extends FastBaseTypography {
  const FastPlaceHolderHeadline({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
    super.upperCase,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getPlaceHolderHeadlineTextStyle(context);
  }
}

/// SUBHEAD
/// 18px
/// semibold
/// uppercase
class FastSubhead extends FastBaseTypography {
  const FastSubhead({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase = true,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSubheadTextStyle(context);
  }
}

/// TITLE
/// 24px
/// regular
/// lowercase
class FastTitle extends FastBaseTypography {
  const FastTitle({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  }) : super(letterSpacing: 1.2);

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getTitleTextStyle(context);
  }
}

/// PLACEHOLDER TITLE
/// 24px
/// light
/// lowercase
class FastPlaceholderTitle extends FastBaseTypography {
  const FastPlaceholderTitle({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getPlaceHolderTitleTextStyle(context);
  }
}

/// SUBTITLE
/// 16px
/// semibold
/// lowercase
class FastSubtitle extends FastBaseTypography {
  const FastSubtitle({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSubtitleTextStyle(context);
  }
}

/// SECONDARY SUBTITLE
/// 14px
/// medium
/// uppercase
class FastSecondarySubtitle extends FastBaseTypography {
  const FastSecondarySubtitle({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase = true,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondarySubtitleTextStyle(context);
  }
}

/// BODY 1
/// 18px
/// normal
/// lowercase
class FastBody extends FastBaseTypography {
  const FastBody({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getBodyTextStyle(context);
  }
}

/// BODY 2
/// 18px
/// normal
/// lowercase
class FastBody2 extends FastBaseTypography {
  @Deprecated('Use FastSecondaryBody')
  const FastBody2({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondaryBodyTextStyle(context);
  }
}

/// SECONDARY BODY
/// 18px
/// normal
/// lowercase
class FastSecondaryBody extends FastBaseTypography {
  const FastSecondaryBody({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondaryBodyTextStyle(context);
  }
}

/// PLACEHOLDER
/// 18px
/// light
/// lowercase
class FastPlaceholder extends FastBaseTypography {
  const FastPlaceholder({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getPlaceholderTextStyle(context);
  }
}

/// BUTTON
/// 16px
/// semibold
/// uppercase
class FastButtonLabel extends FastBaseTypography {
  const FastButtonLabel({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.overflow = TextOverflow.ellipsis,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.softWrap = false,
    super.upperCase = true,
    super.fontWeight,
    super.textColor,
    super.fontSize,
    super.maxLines,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getButtonTextStyle(context);
  }
}

/// SECONDARY BUTTON
/// 14px
/// medium
/// uppercase
class FastSecondaryButton extends FastBaseTypography {
  const FastSecondaryButton({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase = true,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondaryButtonTextStyle(context);
  }
}

/// CAPTION
/// 16px
/// light
/// lowercase
class FastCaption extends FastBaseTypography {
  const FastCaption({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.fontWeight,
    super.upperCase,
    super.textColor,
    super.overflow,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getCaptionTextStyle(context);
  }
}

/// SECONDARY CAPTION
/// 12px
/// medium
/// uppercase
class FastSecondaryCaption extends FastBaseTypography {
  const FastSecondaryCaption({
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase = true,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
    super.key,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondaryCaptionTextStyle(context);
  }
}

/// OVERLINE
/// 14px
/// light
/// lowercase
class FastHelper extends FastBaseTypography {
  @Deprecated('Use FastOverline')
  const FastHelper({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getOverlineTextStyle(context);
  }
}

/// OVERLINE
/// 14px
/// light
/// lowercase
class FastOverline extends FastBaseTypography {
  const FastOverline({
    super.key,
    required super.text,
    super.enableInteractiveSelection = false,
    super.lineHeight = kFastLineHeight,
    super.textAlign = TextAlign.left,
    super.upperCase,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getOverlineTextStyle(context);
  }
}

/// SECONDARY OVERLINE
/// 10px
/// medium
/// uppercase
class FastSecondaryOverline extends FastBaseTypography {
  const FastSecondaryOverline({
    required super.text,
    super.key,
    super.enableInteractiveSelection = false,
    super.textAlign = TextAlign.left,
    super.lineHeight = kFastLineHeight,
    super.upperCase = true,
    super.fontWeight,
    super.overflow,
    super.textColor,
    super.fontSize,
    super.maxLines,
    super.softWrap,
  });

  @override
  TextStyle getDefaultTextStyle(BuildContext context) {
    return ThemeHelper.texts.getSecondaryOverlineTextStyle(context);
  }
}
