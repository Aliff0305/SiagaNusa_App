import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/providers/report_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

/// Pintu masuk fitur laporan masyarakat: buat laporan baru atau lihat riwayat.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ReportProvider>().load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ReportProvider>();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Laporan masyarakat'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Text(
            'Bantu kami memantau kondisi di lapangan.',
            style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Laporan kamu dicek dulu oleh tim sebelum dipakai. Ini bukan pengganti layanan darurat.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: 20),
          AppCard(
            onTap: () => Navigator.pushNamed(context, RouteNames.createReport),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.edit_note,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buat laporan baru',
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Kerusakan, warga terdampak, asap, atau kebutuhan bantuan',
                        style: t.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => Navigator.pushNamed(context, RouteNames.reportHistory),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.history, color: AppColors.info),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Riwayat dan status laporan',
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${p.reports.length} laporan tercatat',
                        style: t.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const InfoBanner(
            icon: Icons.call_outlined,
            color: AppColors.danger,
            message: 'Dalam keadaan darurat, hubungi 112 atau BNPB 117 lebih dulu, baru kirim laporan di sini.',
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.emergencyContacts),
            icon: const Icon(Icons.contacts_outlined),
            label: const Text('Lihat kontak darurat'),
          ),
        ],
      ),
    );
  }
}
