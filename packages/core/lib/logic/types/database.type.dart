typedef DatabaseVersionChanged = Future<void> Function(
  int? oldVersion,
  int? newVersion,
);
