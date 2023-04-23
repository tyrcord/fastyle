import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tmodel/tmodel.dart';
import 'package:tbloc/tbloc.dart';

/// Represents the state of a calculator's bloc.
class FastCalculatorBlocState<F extends FastCalculatorFields,
    R extends FastCalculatorResults> extends BlocState {
  // Optional instance of TModel that can store additional data.
  final TModel? extras;
  // Instance of R that contains the current results of the calculator.
  final R results;
  // Instance of F that contains the current values of the calculator's fields.
  final F fields;
  // A boolean value indicating whether the calculator's fields are currently
  // valid.
  final bool isValid;
  // A boolean value indicating whether the calculator's state has changed
  // since initialization.
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

  /// Creates a new instance of `FastCalculatorBlocState` that is a clone of
  /// the current state.
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

  /// Creates a new instance of `FastCalculatorBlocState` with updated values.
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

  /// Merges the current state with another instance of
  /// `FastCalculatorBlocState`.
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

  /// A list of objects representing the instance variables of the
  /// `FastCalculatorBlocState` class.
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
