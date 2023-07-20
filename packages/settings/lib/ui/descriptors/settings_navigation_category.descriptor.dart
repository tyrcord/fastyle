// Package imports:
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

class FastSettingsNavigationCategoryDescriptor<T> extends FastDescriptor {
  final List<FastItem<T>> items;

  final String? captionText;

  final Color? captionColor;

  final String titleText;

  final Color? titleColor;

  final bool show;

  const FastSettingsNavigationCategoryDescriptor({
    required this.titleText,
    this.items = const [],
    this.show = true,
    this.captionText,
    this.captionColor,
    this.titleColor,
  });

  @override
  FastSettingsNavigationCategoryDescriptor<T> clone() => copyWith();

  @override
  FastSettingsNavigationCategoryDescriptor<T> copyWith({
    List<FastItem<T>>? items,
    String? titleText,
    bool? show,
    String? captionText,
    Color? captionColor,
    Color? titleColor,
  }) {
    return FastSettingsNavigationCategoryDescriptor<T>(
      titleText: titleText ?? this.titleText,
      items: items ?? this.items,
      show: show ?? this.show,
      captionText: captionText ?? this.captionText,
      captionColor: captionColor ?? this.captionColor,
      titleColor: titleColor ?? this.titleColor,
    );
  }

  @override
  FastSettingsNavigationCategoryDescriptor<T> merge(
    covariant FastSettingsNavigationCategoryDescriptor<T> model,
  ) {
    return copyWith(
      titleText: model.titleText,
      items: model.items,
      show: model.show,
      captionText: model.captionText,
      captionColor: model.captionColor,
      titleColor: model.titleColor,
    );
  }

  @override
  List<Object?> get props => [
        titleText,
        items,
        show,
        captionText,
        captionColor,
        titleColor,
      ];
}
