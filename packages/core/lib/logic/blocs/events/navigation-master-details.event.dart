// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

enum FastNavigationSplitViewEventType {
  changed,
}

class FastNavigationSplitViewBlocEvent<T extends FastItem>
    extends BlocEvent<FastNavigationSplitViewEventType, T> {
  const FastNavigationSplitViewBlocEvent({
    required FastNavigationSplitViewEventType type,
    T? item,
  }) : super(type: type, payload: item);

  const FastNavigationSplitViewBlocEvent.changed(T? item)
      : this(
          type: FastNavigationSplitViewEventType.changed,
          item: item,
        );
}
