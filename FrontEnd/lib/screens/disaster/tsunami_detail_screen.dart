import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/tsunami_model.dart';
import 'package:siaganusa/screens/disaster/disaster_detail_screen.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class TsunamiDetailScreen extends StatelessWidget {
  final DisasterModel disaster;
  const TsunamiDetailScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) {
    final ts = disaster.tsunami!;
    final t = Theme.of(context).textTheme;
    final color = Helpers.severityColor(disaster.severity);

    return DisasterDetailScaffold(
      disaster: disaster,
      topChildren: [
        AppCard(
          color: color.withValues(alpha: 0.10),
          child: Row(
            children: [
              Icon(
                ts.status == TsunamiStatus.none
                    ? Icons.check_circle
                    : Icons.warning_amber_rounded,
                color: color,
                size: 36,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ts.status.label,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    Text(
                      ts.isActive
                          ? 'Peringatan sedang aktif'
                          : 'Tidak ada peringatan aktif',
                      style: t.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
      extraChildren: [
        if (ts.regions.isNotEmpty) ...[
          const SectionHeader(title: 'Wilayah yang berpotensi terdampak'),
          AppCard(
            child: Column(
              children: [
                for (final r in ts.regions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: AppColors.tsunami,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(r, style: t.bodyMedium)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        if (ts.status != TsunamiStatus.none) ...[
          const SizedBox(height: 16),
          const InfoBanner(
            icon: Icons.directions_run,
            color: AppColors.danger,
            message: 'Jika berada di pesisir dan merasakan gempa kuat, segera menjauh dari pantai ke tempat tinggi tanpa menunggu peringatan.',
          ),
        ],
      ],
    );
  }
}
