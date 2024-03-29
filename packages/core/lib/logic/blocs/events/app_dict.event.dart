// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastAppDictBlocEvent
    extends BlocEvent<FastAppDictBlocEventType, List<FastDictEntryEntity>> {
  const FastAppDictBlocEvent.init()
      : super(type: FastAppDictBlocEventType.init);

  const FastAppDictBlocEvent.initialized(List<FastDictEntryEntity> payload)
      : super(type: FastAppDictBlocEventType.initialized, payload: payload);

  const FastAppDictBlocEvent.retrieveEntries()
      : super(type: FastAppDictBlocEventType.retrieveEntries);

  const FastAppDictBlocEvent.entriesRetrieved(List<FastDictEntryEntity> payload)
      : super(
            type: FastAppDictBlocEventType.entriesRetrieved, payload: payload);

  const FastAppDictBlocEvent.patchEntries(List<FastDictEntryEntity> payload)
      : super(
          type: FastAppDictBlocEventType.patchEnties,
          payload: payload,
        );

  FastAppDictBlocEvent.patchEntry(String name, dynamic value)
      : super(
          type: FastAppDictBlocEventType.patchEnties,
          payload: [FastDictEntryEntity(name: name, value: value)],
        );

  const FastAppDictBlocEvent.deleteEntries()
      : super(type: FastAppDictBlocEventType.deleteEntries);

  FastAppDictBlocEvent.deleteEntry(String name)
      : super(
          type: FastAppDictBlocEventType.deleteEntries,
          payload: [FastDictEntryEntity(name: name)],
        );
}
