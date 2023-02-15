import 'package:tmodel_dart/logic/core/core.dart';

class SumCalculatorBlocStateExtras extends TModel {
  final bool isFetchingAsyncValue;
  final String asyncValue;

  const SumCalculatorBlocStateExtras({
    this.isFetchingAsyncValue = false,
    this.asyncValue = '',
  });

  @override
  TModel clone() {
    return SumCalculatorBlocStateExtras(
      isFetchingAsyncValue: isFetchingAsyncValue,
      asyncValue: asyncValue,
    );
  }

  @override
  TModel copyWith({bool? isFetchingAsyncValue, String? asyncValue}) {
    return SumCalculatorBlocStateExtras(
      isFetchingAsyncValue: isFetchingAsyncValue ?? this.isFetchingAsyncValue,
      asyncValue: asyncValue ?? this.asyncValue,
    );
  }

  @override
  TModel merge(covariant SumCalculatorBlocStateExtras model) {
    return model.clone();
  }

  @override
  List<Object> get props => [isFetchingAsyncValue, asyncValue];
}
