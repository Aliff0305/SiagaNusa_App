import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/donation_model.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class DonationSuccessScreen extends StatelessWidget {
  final DonationModel donation;
  const DonationSuccessScreen({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Donasi berhasil',
                      style: t.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Terima kasih sudah membantu.', style: t.bodyMedium),
                    const SizedBox(height: 24),
                    AppCard(
                      child: Column(
                        children: [
                          Text(
                            Helpers.rupiah(donation.amount),
                            style: t.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.success,
                            ),
                          ),
                          const Divider(height: 28),
                          _row(context, 'Kampanye', donation.campaignTitle),
                          _row(context, 'Metode', donation.method),
                          _row(
                            context,
                            'Waktu',
                            DateFormatter.dateTime(donation.time),
                          ),
                          _row(context, 'No. bukti', donation.receiptNo),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const InfoBanner(
                      message: 'Pembayaran ini masih simulasi. Belum ada uang yang berpindah.',
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Lihat riwayat donasi',
                      icon: Icons.receipt_long_outlined,
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          (r) =>
                              r.settings.name == RouteNames.main || r.isFirst,
                        );
                        Navigator.pushNamed(
                          context,
                          RouteNames.donationHistory,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: 'Kembali ke beranda',
                      outlined: true,
                      onPressed: () => Navigator.popUntil(
                        context,
                        (r) => r.settings.name == RouteNames.main || r.isFirst,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String k, String v) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(k, style: t.bodySmall)),
          Expanded(
            child: Text(
              v,
              style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
