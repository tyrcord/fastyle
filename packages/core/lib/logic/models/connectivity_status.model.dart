// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tmodel/tmodel.dart';

class FastConnectivityStatus extends TModel {
  final ConnectivityResult connectivityResult;
  final bool isConnected;
  final bool isServiceAvailable;

  const FastConnectivityStatus({
    required this.connectivityResult,
    required this.isConnected,
    required this.isServiceAvailable,
  });

  @override
  FastConnectivityStatus clone() {
    return FastConnectivityStatus(
      connectivityResult: connectivityResult,
      isConnected: isConnected,
      isServiceAvailable: isServiceAvailable,
    );
  }

  @override
  FastConnectivityStatus copyWith({
    ConnectivityResult? connectivityResult,
    bool? isConnected,
    bool? isServiceAvailable,
  }) {
    return FastConnectivityStatus(
      connectivityResult: connectivityResult ?? this.connectivityResult,
      isConnected: isConnected ?? this.isConnected,
      isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
    );
  }

  @override
  FastConnectivityStatus merge(covariant FastConnectivityStatus model) {
    return copyWith(
      connectivityResult: model.connectivityResult,
      isConnected: model.isConnected,
      isServiceAvailable: model.isServiceAvailable,
    );
  }

  @override
  List<Object> get props =>
      [connectivityResult, isConnected, isServiceAvailable];
}
