import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class CampaignDetailScreen extends StatelessWidget {
  final CampaignModel campaign;
  const CampaignDetailScreen({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    // Ambil versi terbaru (progres bisa berubah setelah donasi).
    final c = context.watch<DonationProvider>().byId(campaign.id) ?? campaign;
    final t = Theme.of(context).textTheme;
    final color = Helpers.typeColor(c.type);

    return Scaffold(
      appBar: CustomAppBar(title: 'Detail kampanye'),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: AppButton(
            label: c.verified ? 'Donasi sekarang' : 'Menunggu verifikasi',
            icon: Icons.favorite_outline,
            onPressed: c.verified
                ? () => Navigator.pushNamed(
                    context,
                    RouteNames.payment,
                    arguments: c,
                  )
                : null,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Helpers.typeIcon(c.type), color: color, size: 40),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    c.title,
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Helpers.rupiah(c.collected),
            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            'terkumpul dari ${Helpers.rupiah(c.target)}',
            style: t.bodySmall,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: c.progress,
              minHeight: 10,
              color: AppColors.secondary,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${c.donors} donatur · ${c.daysLeft} hari lagi',
            style: t.bodySmall,
          ),
          const SizedBox(height: 16),
          InfoBanner(
            icon: c.verified ? Icons.verified : Icons.hourglass_top,
            color: c.verified ? AppColors.success : AppColors.warning,
            message: c.verified
                ? 'Kebutuhan bantuan diverifikasi oleh ${c.verifiedBy}.'
                : 'Kampanye belum diverifikasi, donasi belum dibuka.',
          ),
          const SectionHeader(title: 'Tentang kampanye'),
          Text(c.description, style: t.bodyMedium?.copyWith(height: 1.55)),
          const SizedBox(height: 8),
          Text('Penyelenggara: ${c.organizer}', style: t.bodySmall),
          Text('Lokasi: ${c.location}', style: t.bodySmall),
          if (c.allocation.isNotEmpty) ...[
            const SectionHeader(title: 'Rencana penggunaan dana'),
            AppCard(
              child: Column(
                children: [
                  for (final a in c.allocation)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(a.label, style: t.bodyMedium),
                              ),
                              Text(
                                '${a.percent.toStringAsFixed(0)}%',
                                style: t.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: a.percent / 100,
                              minHeight: 6,
                              color: color,
                              backgroundColor: color.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (c.updates.isNotEmpty) ...[
            const SectionHeader(title: 'Kabar terbaru penyaluran'),
            for (final u in c.updates)
              AppCard(
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.shortDate(u.date),
                      style: t.labelSmall?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(u.text, style: t.bodyMedium),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
