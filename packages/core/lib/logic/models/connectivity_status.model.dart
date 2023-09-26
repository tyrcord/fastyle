// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tmodel/tmodel.dart';

class FastConnectivityStatus extends TModel {
  final ConnectivityResult connectivityResult;
  final bool hasConnection;

  const FastConnectivityStatus({
    required this.connectivityResult,
    required this.hasConnection,
  });

  @override
  FastConnectivityStatus clone() {
    return FastConnectivityStatus(
      connectivityResult: connectivityResult,
      hasConnection: hasConnection,
    );
  }

  @override
  FastConnectivityStatus copyWith({
    ConnectivityResult? connectivityResult,
    bool? hasConnection,
  }) {
    return FastConnectivityStatus(
      connectivityResult: connectivityResult ?? this.connectivityResult,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }

  @override
  FastConnectivityStatus merge(covariant FastConnectivityStatus model) {
    return copyWith(
      connectivityResult: model.connectivityResult,
      hasConnection: model.hasConnection,
    );
  }

  @override
  List<Object> get props => [connectivityResult, hasConnection];
}
