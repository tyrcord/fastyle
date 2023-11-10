mixin class FastCalculatorBlocDelegate {
  Future<bool> canAutoRefreshComputations() async => true;

  /// Asynchronously loads and returns metadata as a Map of String to dynamic.
  /// Returns null by default.
  Future<Map<String, dynamic>?> loadMetadata() async => null;

  /// Retrieves the user's currency code.
  /// Returns null by default.
  String? getUserCurrencyCode() => null;

  /// Retrieves the user's locale code.
  /// Returns null by default.
  String? getUserLocaleCode() => null;

  /// Retrieves the user's currency symbol.
  /// Returns null by default.
  String? getUserCurrencySymbol() => null;
}
