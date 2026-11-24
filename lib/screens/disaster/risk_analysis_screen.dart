import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class RiskAnalysisScreen extends StatelessWidget {
  final DisasterModel disaster;
  const RiskAnalysisScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) {
    final a = context.read<DisasterProvider>().analysisFor(disaster);
    final t = Theme.of(context).textTheme;
    final color = Helpers.severityColor(a.riskLevel);

    return Scaffold(
      appBar: CustomAppBar(title: 'Tingkat risiko'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: a.riskScore / 100,
                          strokeWidth: 14,
                          strokeCap: StrokeCap.round,
                          color: color,
                          backgroundColor: color.withValues(alpha: 0.15),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${a.riskScore}',
                            style: t.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: color,
                              height: 1,
                            ),
                          ),
                          Text('dari 100', style: t.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Risiko ${a.riskLevel.label.toLowerCase()}',
                  style: t.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  disaster.title,
                  style: t.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SourceTag(kind: InfoKind.analysis),
          const SectionHeader(title: 'Faktor penilaian'),
          for (final f in a.factors)
            AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          f.name,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${(f.value * 100).round()}%',
                        style: t.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: f.value,
                      minHeight: 8,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.15),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(f.note, style: t.bodySmall),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            a.disclaimer,
            style: t.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }
}
