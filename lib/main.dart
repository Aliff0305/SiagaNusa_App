import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:siaganusa/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  runApp(const SiagaNusaApp());
}
