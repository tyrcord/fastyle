// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastMediaLayoutBloc extends BidirectionalBloc<FastMediaLayoutBlocEvent,
    FastMediaLayoutBlocState> {
  FastMediaLayoutBloc({
    FastMediaLayoutBlocState? initialState,
  }) : super(initialState: initialState ?? FastMediaLayoutBlocState());

  @override
  Stream<FastMediaLayoutBlocState> mapEventToState(
    FastMediaLayoutBlocEvent event,
  ) async* {
    if (event.type == FastMediaLayoutBlocEventType.changed) {
      final mediaType = event.payload as FastMediaType;

      yield currentState.copyWith(mediaType: mediaType);
    }
  }
}
