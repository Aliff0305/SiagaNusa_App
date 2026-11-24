import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/empty_widget.dart';
import 'package:siaganusa/widgets/loading_widget.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({super.key});

  @override
  State<DonationScreen> createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  bool _verifiedOnly = true;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DonationProvider>();
    final t = Theme.of(context).textTheme;
    final list = p.campaigns
        .where((c) => !_verifiedOnly || c.verified)
        .toList();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => p.load(force: true),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Donasi kemanusiaan',
                    style: t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Riwayat donasi',
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.donationHistory),
                  icon: const Icon(Icons.receipt_long_outlined),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const InfoBanner(
              icon: Icons.verified_outlined,
              message: 'Kampanye hanya dibuka setelah kebutuhan bantuan diverifikasi pihak berwenang atau mitra kemanusiaan, bukan otomatis dari magnitudo atau jumlah titik panas.',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilterChip(
                  label: const Text('Terverifikasi saja'),
                  selected: _verifiedOnly,
                  onSelected: (v) => setState(() => _verifiedOnly = v),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.createCampaign),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajukan kampanye'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (p.isLoading && p.campaigns.isEmpty)
              const SizedBox(height: 280, child: LoadingWidget())
            else if (list.isEmpty)
              const SizedBox(
                height: 280,
                child: EmptyWidget(
                  icon: Icons.volunteer_activism_outlined,
                  title: 'Belum ada kampanye',
                  message: 'Kampanye terverifikasi akan muncul saat ada kebutuhan bantuan.',
                ),
              )
            else
              for (final c in list)
                CampaignCard(
                  campaign: c,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.campaignDetail,
                    arguments: c,
                  ),
                ),
            if (p.totalDonated > 0)
              Center(
                child: Text(
                  'Total donasimu: ${Helpers.rupiah(p.totalDonated)}',
                  style: t.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CampaignCard extends StatelessWidget {
  final CampaignModel campaign;
  final VoidCallback onTap;

  const CampaignCard({super.key, required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = Helpers.typeColor(campaign.type);

    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 84,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(Helpers.typeIcon(campaign.type), color: color, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    campaign.type.label,
                    style: t.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _VerifiedChip(verified: campaign.verified),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(campaign.location, style: t.bodySmall),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: campaign.progress,
                    minHeight: 8,
                    color: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        Helpers.rupiahCompact(campaign.collected),
                        style: t.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      'dari ${Helpers.rupiahCompact(campaign.target)}',
                      style: t.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${campaign.donors} donatur · ${campaign.daysLeft} hari lagi',
                  style: t.labelSmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  final bool verified;
  const _VerifiedChip({required this.verified});

  @override
  Widget build(BuildContext context) {
    final c = verified ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.verified : Icons.hourglass_top,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            verified ? 'Terverifikasi' : 'Menunggu verifikasi',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
