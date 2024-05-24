// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tmodel/tmodel.dart';

class FastConnectivityStatus extends TModel {
  final List<ConnectivityResult> connectivityResults;
  final bool isConnected;
  final bool isServiceAvailable;

  const FastConnectivityStatus({
    required this.connectivityResults,
    required this.isConnected,
    required this.isServiceAvailable,
  });

  @override
  FastConnectivityStatus clone() {
    return FastConnectivityStatus(
      connectivityResults: connectivityResults,
      isConnected: isConnected,
      isServiceAvailable: isServiceAvailable,
    );
  }

  @override
  FastConnectivityStatus copyWith({
    List<ConnectivityResult>? connectivityResults,
    bool? isConnected,
    bool? isServiceAvailable,
  }) {
    return FastConnectivityStatus(
      connectivityResults: connectivityResults ?? this.connectivityResults,
      isConnected: isConnected ?? this.isConnected,
      isServiceAvailable: isServiceAvailable ?? this.isServiceAvailable,
    );
  }

  @override
  FastConnectivityStatus merge(covariant FastConnectivityStatus model) {
    return copyWith(
      connectivityResults: model.connectivityResults,
      isConnected: model.isConnected,
      isServiceAvailable: model.isServiceAvailable,
    );
  }

  @override
  List<Object> get props =>
      [connectivityResults, isConnected, isServiceAvailable];
}
