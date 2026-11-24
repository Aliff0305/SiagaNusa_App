import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/providers/dashboard_provider.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';
import 'package:siaganusa/widgets/disaster_badge.dart';

class ImpactAnalysisScreen extends StatelessWidget {
  final DisasterModel disaster;
  const ImpactAnalysisScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) {
    final a = context.read<DisasterProvider>().analysisFor(disaster);
    final t = Theme.of(context).textTheme;

    Widget bullets(List<String> items, IconData icon, Color color) => AppCard(
      child: Column(
        children: [
          for (final s in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s, style: t.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Analisis dampak'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          Text(
            disaster.title,
            style: t.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(disaster.location, style: t.bodyMedium),
          const SizedBox(height: 14),
          Row(
            children: [
              Text('Tingkat risiko:', style: t.bodyMedium),
              const SizedBox(width: 8),
              DisasterBadge(severity: a.riskLevel),
            ],
          ),
          const SizedBox(height: 16),
          const SourceTag(kind: InfoKind.estimate),
          const SectionHeader(title: 'Dampak yang mungkin terjadi'),
          bullets(a.potentialImpacts, Icons.arrow_right_alt, AppColors.warning),
          const SectionHeader(title: 'Penyebab fenomena'),
          bullets(a.causes, Icons.lightbulb_outline, AppColors.info),
          const SectionHeader(title: 'Yang sebaiknya dilakukan'),
          bullets(
            a.recommendations,
            Icons.check_circle_outline,
            AppColors.success,
          ),
          const SizedBox(height: 16),
          Text(
            a.disclaimer,
            style: t.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Lihat tingkat risiko',
            icon: Icons.speed,
            onPressed: () => Navigator.pushNamed(
              context,
              RouteNames.riskAnalysis,
              arguments: disaster,
            ),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Buka panduan mitigasi',
            icon: Icons.health_and_safety_outlined,
            outlined: true,
            onPressed: () {
              context.read<DashboardProvider>().setTab(3);
              Navigator.popUntil(context, (r) => r.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
