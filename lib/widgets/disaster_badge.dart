import 'package:flutter/material.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';

class DisasterBadge extends StatelessWidget {
  final Severity severity;
  final bool onDark;

  const DisasterBadge({super.key, required this.severity, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final c = Helpers.severityColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: onDark ? Colors.white : c.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity.label,
        style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w800),
      ),
    );
  }
}
