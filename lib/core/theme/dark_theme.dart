import 'package:flutter/material.dart';
import 'package:siaganusa/core/theme/app_theme.dart';

class DarkTheme {
  DarkTheme._();
  static ThemeData get theme => AppTheme.build(Brightness.dark);
}
