// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

/// Represents the state of the FastAppDictBloc.
class FastAppDictBlocState extends BlocState {
  /// The list of FastDictEntryEntity objects.
  final List<FastDictEntryEntity> entries;

  /// Whether the entries are currently being retrieved.
  final bool isRetrievingEntries;

  /// Constructs a [FastAppDictBlocState] instance.
  ///
  /// The [entries] parameter is optional and defaults to an empty list if not provided.
  FastAppDictBlocState({
    super.isInitializing,
    super.isInitialized,
    List<FastDictEntryEntity>? entries,
    bool? isRetrievingEntries,
  })  : entries = entries ?? const [],
        isRetrievingEntries = isRetrievingEntries ?? false;

  @override
  FastAppDictBlocState copyWith({
    List<FastDictEntryEntity>? entries,
    bool? isInitializing,
    bool? isInitialized,
    bool? isRetrievingEntries,
  }) {
    return FastAppDictBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      entries: entries ?? this.entries,
      isRetrievingEntries: isRetrievingEntries ?? this.isRetrievingEntries,
    );
  }

  @override
  FastAppDictBlocState clone() => copyWith();

  @override
  FastAppDictBlocState merge(covariant FastAppDictBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      entries: model.entries,
      isRetrievingEntries: model.isRetrievingEntries,
    );
  }

  @override
  List<Object?> get props => [
        entries,
        isInitialized,
        isInitializing,
        isRetrievingEntries,
      ];
}
