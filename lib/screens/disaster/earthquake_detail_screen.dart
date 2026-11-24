import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/screens/disaster/disaster_detail_screen.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class EarthquakeDetailScreen extends StatelessWidget {
  final DisasterModel disaster;
  const EarthquakeDetailScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) {
    final eq = disaster.earthquake!;
    final t = Theme.of(context).textTheme;
    return DisasterDetailScaffold(
      disaster: disaster,
      topChildren: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              eq.magnitude.toStringAsFixed(1),
              style: t.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.earthquake,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('magnitudo', style: t.titleSmall),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InfoBanner(
          icon: eq.hasTsunamiPotential
              ? Icons.warning_amber_rounded
              : Icons.check_circle_outline,
          color: eq.hasTsunamiPotential ? AppColors.danger : AppColors.success,
          message: eq.potential,
        ),
        const SizedBox(height: 16),
      ],
      extraChildren: const [
        SizedBox(height: 12),
        InfoBanner(
          message: 'Parameter gempa dapat diperbarui BMKG setelah analisis lanjutan. Cek kembali informasi terbaru.',
        ),
      ],
    );
  }
}
