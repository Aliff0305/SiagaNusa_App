import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/models/disaster_model.dart';

class Helpers {
  Helpers._();

  static Color typeColor(DisasterType t) => switch (t) {
    DisasterType.earthquake => AppColors.earthquake,
    DisasterType.tsunami => AppColors.tsunami,
    DisasterType.wildfire => AppColors.wildfire,
  };

  static IconData typeIcon(DisasterType t) => switch (t) {
    DisasterType.earthquake => Icons.vibration,
    DisasterType.tsunami => Icons.tsunami,
    DisasterType.wildfire => Icons.local_fire_department,
  };

  static Color severityColor(Severity s) => switch (s) {
    Severity.low => AppColors.success,
    Severity.moderate => AppColors.warning,
    Severity.high => AppColors.earthquake,
    Severity.critical => AppColors.danger,
  };

  static String rupiah(num value) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(value);

  static String rupiahCompact(num v) {
    if (v >= 1000000000) return 'Rp ${(v / 1000000000).toStringAsFixed(1)} M';
    if (v >= 1000000) return 'Rp ${(v / 1000000).toStringAsFixed(1)} jt';
    if (v >= 1000) return 'Rp ${(v / 1000).toStringAsFixed(0)} rb';
    return 'Rp ${v.toStringAsFixed(0)}';
  }

  static void snack(
    BuildContext context,
    String message, {
    bool error = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? AppColors.danger : null,
        ),
      );
  }
}
