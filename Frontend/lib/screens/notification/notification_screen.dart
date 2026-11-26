import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/providers/notification_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/disaster_badge.dart';
import 'package:siaganusa/widgets/empty_widget.dart';
import 'package:siaganusa/widgets/loading_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<NotificationProvider>();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peringatan'),
        actions: [
          if (p.unreadCount > 0)
            TextButton(
              onPressed: p.markAllRead,
              child: const Text('Tandai dibaca'),
            ),
        ],
      ),
      body: p.isLoading
          ? const LoadingWidget()
          : p.items.isEmpty
          ? const EmptyWidget(
              icon: Icons.notifications_off_outlined,
              title: 'Belum ada peringatan',
              message: 'Peringatan gempa, tsunami, dan karhutla akan muncul di sini.',
            )
          : RefreshIndicator(
              onRefresh: () => p.load(force: true),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                itemCount: p.items.length,
                itemBuilder: (_, i) {
                  final n = p.items[i];
                  final color = Helpers.typeColor(n.type);
                  return AppCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    onTap: () {
                      p.markRead(n.id);
                      Navigator.pushNamed(
                        context,
                        RouteNames.notificationDetail,
                        arguments: n,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Helpers.typeIcon(n.type), color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      n.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.titleSmall?.copyWith(
                                        fontWeight: n.isRead
                                            ? FontWeight.w600
                                            : FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  if (!n.isRead)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      width: 9,
                                      height: 9,
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                n.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: t.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  DisasterBadge(severity: n.severity),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormatter.ago(n.time),
                                    style: t.labelSmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
