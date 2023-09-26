// Package imports:
import 'package:tbloc/tbloc.dart';

class FastConnectivityStatusBlocState extends BlocState {
  final bool hasConnection;

  FastConnectivityStatusBlocState({
    required this.hasConnection,
    super.isInitialized,
    super.isInitializing,
  });

  @override
  FastConnectivityStatusBlocState clone() {
    return FastConnectivityStatusBlocState(
      hasConnection: hasConnection,
      isInitialized: isInitialized,
      isInitializing: isInitializing,
    );
  }

  @override
  FastConnectivityStatusBlocState copyWith({
    bool? hasConnection,
    bool? isInitialized,
    bool? isInitializing,
  }) {
    return FastConnectivityStatusBlocState(
      hasConnection: hasConnection ?? this.hasConnection,
      isInitialized: isInitialized ?? this.isInitialized,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }

  @override
  FastConnectivityStatusBlocState merge(
    covariant FastConnectivityStatusBlocState model,
  ) {
    return copyWith(
      hasConnection: model.hasConnection,
      isInitialized: model.isInitialized,
      isInitializing: model.isInitializing,
    );
  }

  @override
  List<Object?> get props => [hasConnection, isInitialized, isInitializing];
}
