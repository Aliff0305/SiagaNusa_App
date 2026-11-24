import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/models/report_model.dart';
import 'package:siaganusa/providers/report_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';
import 'package:siaganusa/widgets/empty_widget.dart';
import 'package:siaganusa/widgets/loading_widget.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ReportProvider>().load(force: true),
    );
  }

  Color _color(ReportStatus s) => switch (s) {
    ReportStatus.pending => AppColors.warning,
    ReportStatus.verifying => AppColors.info,
    ReportStatus.verified => AppColors.success,
    ReportStatus.rejected => AppColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReportProvider>();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Laporan saya'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, RouteNames.createReport),
        icon: const Icon(Icons.add),
        label: const Text('Laporan baru'),
      ),
      body: p.isLoading && p.reports.isEmpty
          ? const LoadingWidget()
          : p.reports.isEmpty
          ? const EmptyWidget(
              icon: Icons.edit_note,
              title: 'Belum ada laporan',
              message: 'Laporan kondisi lapangan yang kamu kirim akan tampil di sini.',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
              itemCount: p.reports.length,
              itemBuilder: (_, i) {
                final r = p.reports[i];
                final c = _color(r.status);
                return AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              r.category,
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: c.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              r.status.label,
                              style: TextStyle(
                                color: c,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(r.location, style: t.bodySmall),
                      const SizedBox(height: 8),
                      Text(r.description, style: t.bodyMedium),
                      if (r.photoName != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.photo_outlined, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                r.photoName!,
                                overflow: TextOverflow.ellipsis,
                                style: t.labelSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (r.note != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Catatan: ${r.note}',
                          style: t.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        DateFormatter.ago(r.createdAt),
                        style: t.labelSmall?.copyWith(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
