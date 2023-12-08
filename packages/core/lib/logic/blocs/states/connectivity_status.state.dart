// Package imports:
import 'package:tbloc/tbloc.dart';

class FastConnectivityStatusBlocState extends BlocState {
  final bool isConnected;
  final bool isServiceAvailable;
  final bool isCheckingConnectivity;

  FastConnectivityStatusBlocState({
    this.isServiceAvailable = false,
    this.isConnected = false,
    this.isCheckingConnectivity = false,
    super.isInitialized,
    super.isInitializing,
  });

  @override
  FastConnectivityStatusBlocState clone() => copyWith();

  @override
  FastConnectivityStatusBlocState copyWith({
    bool? isConnected,
    bool? isServiceAvailable,
    bool? isInitialized,
    bool? isInitializing,
    bool? isCheckingConnectivity,
  }) {
    return FastConnectivityStatusBlocState(
      isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
      isInitializing: isInitializing ?? this.isInitializing,
      isConnected: isConnected ?? this.isConnected,
      isInitialized: isInitialized ?? this.isInitialized,
      isCheckingConnectivity:
          isCheckingConnectivity ?? this.isCheckingConnectivity,
    );
  }

  @override
  FastConnectivityStatusBlocState merge(
    covariant FastConnectivityStatusBlocState model,
  ) {
    return copyWith(
      isServiceAvailable: model.isServiceAvailable,
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      isConnected: model.isConnected,
      isCheckingConnectivity: model.isCheckingConnectivity,
    );
  }

  @override
  List<Object?> get props => [
        isServiceAvailable,
        isInitialized,
        isInitializing,
        isCheckingConnectivity,
        isConnected,
      ];
}
