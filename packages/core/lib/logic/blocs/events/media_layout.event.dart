// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

enum FastMediaLayoutBlocEventType {
  changed,
}

class FastMediaLayoutBlocEvent
    extends BlocEvent<FastMediaLayoutBlocEventType, FastMediaType> {
  const FastMediaLayoutBlocEvent({
    required FastMediaLayoutBlocEventType type,
    FastMediaType? mediaType,
  }) : super(type: type, payload: mediaType);

  const FastMediaLayoutBlocEvent.changed(FastMediaType mediaType)
      : this(
          type: FastMediaLayoutBlocEventType.changed,
          mediaType: mediaType,
        );
}
