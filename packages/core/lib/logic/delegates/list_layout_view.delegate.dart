// Importing necessary packages
// UI utilities for Fastyle Dart
import 'package:flutter/material.dart'; // Flutter widgets framework

import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

/// An abstract class that defines a delegate object for
/// the [FastListViewLayout] widget.
///
/// The purpose of this delegate object is to provide a way to customize the
/// appearance and behavior of the [FastListViewLayout] widget.
/// Subclasses of [FastListViewLayoutDelegate] must implement
/// the [willBuildListViewForCategory] method to provide the view for each
/// category of items.
abstract class FastListViewLayoutDelegate<T extends FastItem> {
  /// Builds the list view for the given category of items
  ///
  /// The [listViewLayout] argument can be used to acces its public method and
  /// the [category] argument provides information about the category,
  /// such as its  title and items. This method should return a widget that
  /// represents the view for the given category.
  Widget? willBuildListViewForCategory(
    FastListViewLayout listViewLayout,
    FastListItemCategory<T> category,
  );
}
