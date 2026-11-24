import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class _Contact {
  final String name;
  final String number;
  final String desc;
  final IconData icon;
  const _Contact(this.name, this.number, this.desc, this.icon);
}

class EmergencyContactScreen extends StatelessWidget {
  const EmergencyContactScreen({super.key});

  static const _contacts = [
    _Contact(
      'BNPB',
      '117',
      'Badan Nasional Penanggulangan Bencana',
      Icons.shield_outlined,
    ),
    _Contact(
      'Basarnas',
      '115',
      'Pencarian dan pertolongan',
      Icons.sailing_outlined,
    ),
    _Contact(
      'Ambulans',
      '118',
      'Layanan gawat darurat medis',
      Icons.local_hospital_outlined,
    ),
    _Contact('Polisi', '110', 'Kepolisian', Icons.local_police_outlined),
    _Contact(
      'Pemadam kebakaran',
      '113',
      'Kebakaran dan penyelamatan',
      Icons.fire_truck_outlined,
    ),
    _Contact('PLN', '123', 'Gangguan listrik', Icons.bolt_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: CustomAppBar(title: 'Kontak darurat'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const InfoBanner(
            icon: Icons.copy_outlined,
            message: 'Ketuk kartu untuk menyalin nomor, lalu panggil dari aplikasi telepon. Verifikasi nomor sebelum rilis aplikasi.',
          ),
          const SizedBox(height: 16),
          for (final c in _contacts)
            AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: c.number));
                if (context.mounted) {
                  Helpers.snack(context, 'Nomor ${c.number} disalin');
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(c.icon, color: AppColors.danger),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(c.desc, style: t.bodySmall),
                      ],
                    ),
                  ),
                  Text(
                    c.number,
                    style: t.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.danger,
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
