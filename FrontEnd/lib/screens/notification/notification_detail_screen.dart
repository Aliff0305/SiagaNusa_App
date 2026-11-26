import 'package:flutter/material.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/notification_model.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';
import 'package:siaganusa/widgets/disaster_badge.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel item;
  const NotificationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = Helpers.typeColor(item.type);

    return Scaffold(
      appBar: CustomAppBar(title: 'Detail peringatan'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Row(
            children: [
              Icon(Helpers.typeIcon(item.type), color: color),
              const SizedBox(width: 8),
              Text(
                item.type.label,
                style: t.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              DisasterBadge(severity: item.severity),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.title,
            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(DateFormatter.dateTime(item.time), style: t.bodySmall),
          const SizedBox(height: 20),
          SourceTag(
            kind: InfoKind.official,
            source: item.source,
            showHint: false,
          ),
          const SizedBox(height: 20),
          Text(item.body, style: t.bodyLarge?.copyWith(height: 1.55)),
        ],
      ),
    );
  }
}
