// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationSplitViewBloc extends BidirectionalBloc<
    FastNavigationSplitViewBlocEvent, FastNavigationSplitViewState> {
  FastNavigationSplitViewBloc({
    FastNavigationSplitViewState? initialState,
  }) : super(
          initialState: initialState ?? FastNavigationSplitViewState(),
        );

  @override
  Stream<FastNavigationSplitViewState> mapEventToState(
    FastNavigationSplitViewBlocEvent event,
  ) async* {
    if (event.type == FastNavigationSplitViewEventType.changed) {
      var item = event.payload;

      yield currentState.copyWith(item: item);
    }
  }
}
