import 'package:flutter/material.dart';
import 'package:siaganusa/screens/mitigation/mitigation_screen.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class MitigationDetailScreen extends StatelessWidget {
  final MitigationGuide guide;
  const MitigationDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(title: guide.title),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          for (final step in guide.steps) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 22,
                    decoration: BoxDecoration(
                      color: guide.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    step.phase,
                    style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  for (final a in step.actions)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 18,
                            color: guide.color,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              a,
                              style: t.bodyMedium?.copyWith(height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 4),
          const InfoBanner(
            message: 'Panduan umum. Untuk arahan terbaru, ikuti BNPB, BMKG, dan BPBD setempat.',
          ),
        ],
      ),
    );
  }
}
