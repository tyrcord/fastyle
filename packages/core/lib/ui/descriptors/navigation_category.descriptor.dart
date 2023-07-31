// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastNavigationCategoryDescriptor<T> extends FastDescriptor {
  final List<FastItem<T>> items;

  final String? captionText;

  final Color? captionColor;

  final String titleText;

  final Color? titleColor;

  final bool show;

  const FastNavigationCategoryDescriptor({
    required this.titleText,
    this.items = const [],
    this.show = true,
    this.captionText,
    this.captionColor,
    this.titleColor,
  });

  @override
  FastNavigationCategoryDescriptor<T> clone() => copyWith();

  @override
  FastNavigationCategoryDescriptor<T> copyWith({
    List<FastItem<T>>? items,
    String? titleText,
    bool? show,
    String? captionText,
    Color? captionColor,
    Color? titleColor,
  }) {
    return FastNavigationCategoryDescriptor<T>(
      titleText: titleText ?? this.titleText,
      items: items ?? this.items,
      show: show ?? this.show,
      captionText: captionText ?? this.captionText,
      captionColor: captionColor ?? this.captionColor,
      titleColor: titleColor ?? this.titleColor,
    );
  }

  @override
  FastNavigationCategoryDescriptor<T> merge(
    covariant FastNavigationCategoryDescriptor<T> model,
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
