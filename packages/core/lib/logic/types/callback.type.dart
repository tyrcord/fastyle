//TODO: @need-review: code from fastyle_dart

/// A callback that takes a [dynamic] value and returns a [String].
typedef StringCallback<V> = String Function(V value);

/// A callback that takes a [dynamic] value and returns a [bool].
typedef BoolCallback<V> = bool Function(V value);

/// A callback that takes a [dynamic] value and returns a [int].
typedef IntCallback<V> = int Function(V value);

/// A callback that takes a [dynamic] value and returns a [double].
typedef DoubleCallback<V> = double Function(V value);

typedef FutureBoolCallback<V> = Future<bool> Function();

typedef Callback<V> = void Function(V value);

typedef FutureVoidCallback<V> = Future<void> Function(V value);
