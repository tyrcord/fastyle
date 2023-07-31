// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastNavigationSplitViewState extends BlocState {
  final FastItem? item;
  final bool isLoading;
  final bool isLoaded;

  FastNavigationSplitViewState({
    this.isLoading = false,
    this.isLoaded = false,
    this.item,
  });

  @override
  FastNavigationSplitViewState clone() => copyWith();

  @override
  FastNavigationSplitViewState copyWith({
    FastItem? item,
    bool? isLoading,
    bool? isLoaded,
  }) {
    return FastNavigationSplitViewState(
      item: item ?? this.item,
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }

  @override
  FastNavigationSplitViewState merge(
    covariant FastNavigationSplitViewState model,
  ) {
    return copyWith(
      item: model.item,
      isLoading: model.isLoading,
      isLoaded: model.isLoaded,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoaded, item];
}
