// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// Class that describes some visual aspects of an item.
class FastListItemDescriptor extends FastDescriptor {
  /// A widget to display after an item label.
  final Widget? trailing;

  /// A widget to display before an item label.
  final Widget? leading;

  /// Specifies whether an item will have the vertically dense layout.
  final bool isDense;

  /// The padding of the item.
  final EdgeInsets? padding;

  /// The color of the label text when the item is selected.
  final Color? selectionLabelColor;

  /// The color of the item when it is selected.
  final Color? selectionColor;

  const FastListItemDescriptor({
    this.isDense = true,
    this.trailing,
    this.leading,
    this.padding,
    this.selectionLabelColor,
    this.selectionColor,
  });

  /// Creates a new instance of [FastListItemDescriptor] that is a copy of the
  /// current instance.
  @override
  FastListItemDescriptor clone() => copyWith();

  /// Creates a new instance of [FastListItemDescriptor] that is a copy of the
  /// current instance, but with some properties overridden.
  @override
  FastListItemDescriptor copyWith({
    Widget? trailing,
    Widget? leading,
    bool? isDense,
    EdgeInsets? padding,
    Color? selectionLabelColor,
    Color? selectionColor,
  }) {
    return FastListItemDescriptor(
      trailing: trailing ?? this.trailing,
      isDense: isDense ?? this.isDense,
      leading: leading ?? this.leading,
      padding: padding ?? this.padding,
      selectionLabelColor: selectionLabelColor ?? this.selectionLabelColor,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }

  /// Creates a new instance of [FastListItemDescriptor] that is a combination
  /// of the current instance and another instance of [FastListItemDescriptor].
  @override
  FastListItemDescriptor merge(covariant FastListItemDescriptor model) {
    return copyWith(
      trailing: model.trailing,
      isDense: model.isDense,
      leading: model.leading,
      padding: model.padding,
      selectionLabelColor: model.selectionLabelColor,
      selectionColor: model.selectionColor,
    );
  }

  /// Returns a list of the object's properties, which is used to compare
  /// instances of the class for equality.
  @override
  List<Object?> get props => [
        trailing,
        isDense,
        leading,
        padding,
        selectionLabelColor,
        selectionColor,
      ];
}
