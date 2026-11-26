import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/screens/disaster/disaster_detail_screen.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class HotspotDetailScreen extends StatelessWidget {
  final DisasterModel disaster;
  const HotspotDetailScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) {
    final hs = disaster.hotspot!;
    final t = Theme.of(context).textTheme;
    final color = Helpers.severityColor(hs.severity);

    return DisasterDetailScaffold(
      disaster: disaster,
      topChildren: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tingkat kepercayaan satelit',
                      style: t.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${hs.confidence}%',
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: hs.confidence / 100,
                  minHeight: 10,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(height: 8),
              Text('Kategori: ${hs.confidenceLabel}', style: t.bodySmall),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const InfoBanner(
          icon: Icons.info_outline,
          color: AppColors.warning,
          message: 'Titik panas adalah anomali suhu yang terdeteksi satelit. Belum tentu kebakaran. Perlu verifikasi petugas di lapangan.',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
