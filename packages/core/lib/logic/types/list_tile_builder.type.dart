// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

typedef FastListItemBuilder<T extends FastItem> = Widget Function(
  BuildContext context,
  T item,
  int index,
);
