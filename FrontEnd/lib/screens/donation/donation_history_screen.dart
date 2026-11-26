import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/donation_model.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';
import 'package:siaganusa/widgets/empty_widget.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  void _showReceipt(BuildContext context, DonationModel d) {
    final t = Theme.of(context).textTheme;
    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(k, style: t.bodySmall)),
          Expanded(
            child: Text(
              v,
              style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bukti donasi',
                style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              row('No. bukti', d.receiptNo),
              row('Kampanye', d.campaignTitle),
              row('Nominal', Helpers.rupiah(d.amount)),
              row('Metode', d.method),
              row('Waktu', DateFormatter.dateTime(d.time)),
              row('Status', d.status),
              row(
                'Nama donatur',
                d.anonymous ? 'Anonim' : 'Tercatat atas nama akun',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DonationProvider>();
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CustomAppBar(title: 'Riwayat donasi'),
      body: p.history.isEmpty
          ? const EmptyWidget(
              icon: Icons.receipt_long_outlined,
              title: 'Belum ada donasi',
              message: 'Donasi yang kamu lakukan beserta bukti transaksinya tampil di sini.',
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              itemCount: p.history.length,
              itemBuilder: (_, i) {
                final d = p.history[i];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => _showReceipt(context, d),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.campaignTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '${DateFormatter.shortDate(d.time)} · ${d.method}',
                              style: t.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        Helpers.rupiah(d.amount),
                        style: t.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
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
