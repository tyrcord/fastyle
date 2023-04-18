import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tmodel/tmodel.dart';
import 'package:tbloc/tbloc.dart';

class FastCalculatorBlocState<F extends FastCalculatorFields,
    R extends FastCalculatorResults> extends BlocState {
  final TModel? extras;
  final R results;
  final F fields;
  final bool isValid;
  final bool isDirty;

  const FastCalculatorBlocState({
    super.isInitializing,
    super.isInitialized,
    super.isBusy,
    required this.results,
    required this.fields,
    this.isValid = false,
    this.isDirty = false,
    this.extras,
  });

  @override
  FastCalculatorBlocState<F, R> clone() {
    return FastCalculatorBlocState<F, R>(
      extras: extras,
      isInitializing: isInitializing,
      isInitialized: isInitialized,
      results: results.clone() as R,
      fields: fields.clone() as F,
      isValid: isValid,
      isDirty: isDirty,
      isBusy: isBusy,
    );
  }

  @override
  FastCalculatorBlocState<F, R> copyWith({
    TModel? extras,
    bool? isInitializing,
    bool? isInitialized,
    R? results,
    F? fields,
    bool? isValid,
    bool? isDirty,
    bool? isBusy,
  }) {
    return FastCalculatorBlocState<F, R>(
      extras: extras ?? this.extras,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      results: results ?? this.results,
      fields: fields ?? this.fields,
      isValid: isValid ?? this.isValid,
      isDirty: isDirty ?? this.isDirty,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  FastCalculatorBlocState<F, R> merge(
    covariant FastCalculatorBlocState<F, R> model,
  ) {
    return copyWith(
      extras: model.extras != null ? extras?.merge(model.extras!) : null,
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      results: results.merge(model.results) as R,
      fields: fields.merge(model.fields) as F,
      isValid: model.isValid,
      isDirty: model.isDirty,
      isBusy: model.isBusy,
    );
  }

  @override
  List<Object?> get props => [
        extras,
        isInitializing,
        isInitialized,
        results,
        fields,
        isValid,
        isDirty,
        isBusy,
      ];
}
