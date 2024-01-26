// Package imports:
import 'package:tstore/tstore.dart';

Future<void> clearFastAppData() async {
  final database = TFlutterDataBase();

  return database.clearActiveStores();
}
