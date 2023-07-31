// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastMediaLayoutBlocState extends BlocState {
  final FastMediaType mediaType;
  final bool isLoading;
  final bool isLoaded;

  FastMediaLayoutBlocState({
    this.mediaType = FastMediaType.handset,
    this.isLoading = false,
    this.isLoaded = false,
  });

  @override
  FastMediaLayoutBlocState clone() => copyWith();

  @override
  FastMediaLayoutBlocState copyWith({
    FastMediaType? mediaType,
    bool? isLoading,
    bool? isLoaded,
  }) {
    return FastMediaLayoutBlocState(
      mediaType: mediaType ?? this.mediaType,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  FastMediaLayoutBlocState merge(covariant FastMediaLayoutBlocState model) {
    return copyWith(
      mediaType: model.mediaType,
      isLoading: model.isLoading,
      isLoaded: model.isLoaded,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoaded, mediaType];
}
