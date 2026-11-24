import 'package:flutter/material.dart';
import 'package:siaganusa/core/theme/app_theme.dart';

class LightTheme {
  LightTheme._();
  static ThemeData get theme => AppTheme.build(Brightness.light);
}
