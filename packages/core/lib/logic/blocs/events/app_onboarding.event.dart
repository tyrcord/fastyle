// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppOnboardingBlocEvent extends BlocEvent<
    FastAppOnboardingBlocEventType, FastAppOnboardingBlocEventPayload> {
  const FastAppOnboardingBlocEvent.init()
      : super(type: FastAppOnboardingBlocEventType.init);

  const FastAppOnboardingBlocEvent.initialized(
    FastAppOnboardingBlocEventPayload payload,
  ) : super(type: FastAppOnboardingBlocEventType.initialized, payload: payload);

  const FastAppOnboardingBlocEvent.initializationCompleted()
      : super(type: FastAppOnboardingBlocEventType.initializationCompleted);
}
