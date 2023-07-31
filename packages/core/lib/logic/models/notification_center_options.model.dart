// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tmodel/tmodel.dart';

//TODO: @need-review: code from fastyle_dart

class FastNotificationCenterOptions extends TModel {
  ///
  /// A widget to display before the notification title.
  ///
  final Widget? leadingIcon;

  ///
  /// Represents the color to use when drawing an icon.
  ///
  final Color? iconColor;

  ///
  /// Represents the size of the icon in logical pixels.
  ///
  final double? iconSize;

  const FastNotificationCenterOptions({
    this.leadingIcon,
    this.iconColor,
    this.iconSize,
  });

  @override
  FastNotificationCenterOptions copyWith({
    Widget? leadingIcon,
    Color? iconColor,
    double? iconSize,
  }) {
    return FastNotificationCenterOptions(
      leadingIcon: leadingIcon ?? this.leadingIcon,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
    );
  }

  @override
  FastNotificationCenterOptions clone() => copyWith();

  @override
  FastNotificationCenterOptions merge(
    covariant FastNotificationCenterOptions model,
  ) {
    return copyWith(
      leadingIcon: model.leadingIcon,
      iconColor: model.iconColor,
      iconSize: model.iconSize,
    );
  }

  @override
  List<Object?> get props => [leadingIcon, iconColor, iconSize];
}
