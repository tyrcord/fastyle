// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastMediaLayoutBloc extends BidirectionalBloc<FastMediaLayoutBlocEvent,
    FastMediaLayoutBlocState> {
  static bool _hasBeenInstantiated = false;
  static late FastMediaLayoutBloc instance;

  FastMediaLayoutBloc._({FastMediaLayoutBlocState? initialState})
      : super(initialState: initialState ?? FastMediaLayoutBlocState());

  factory FastMediaLayoutBloc({FastMediaLayoutBlocState? initialState}) {
    if (!_hasBeenInstantiated) {
      instance = FastMediaLayoutBloc._(initialState: initialState);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

    @override
  bool canClose() => false;

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
