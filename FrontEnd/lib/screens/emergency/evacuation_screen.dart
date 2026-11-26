import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class _Block {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
  const _Block(this.title, this.icon, this.color, this.items);
}

class EvacuationScreen extends StatelessWidget {
  const EvacuationScreen({super.key});

  static const _blocks = [
    _Block('Rencanakan sebelum bencana', Icons.map_outlined, AppColors.info, [
      'Cari tahu jalur evakuasi dan titik kumpul resmi di sekitar rumah, kantor, dan sekolah.',
      'Tentukan satu titik temu keluarga bila terpisah.',
      'Catat nomor kontak keluarga dan simpan di tas siaga.',
      'Latih rencana ini bersama seluruh anggota keluarga, termasuk anak dan lansia.',
    ]),
    _Block('Saat harus evakuasi', Icons.directions_run, AppColors.danger, [
      'Ikuti arahan petugas dan informasi resmi BMKG, BNPB, atau BPBD.',
      'Bawa tas siaga, jangan kembali untuk mengambil barang lain.',
      'Untuk tsunami, utamakan berjalan kaki menuju tempat tinggi.',
      'Bantu anak, lansia, dan penyandang disabilitas lebih dulu.',
      'Matikan listrik dan gas bila masih sempat dan aman.',
    ]),
    _Block(
      'Di tempat pengungsian',
      Icons.night_shelter_outlined,
      AppColors.secondary,
      [
        'Lapor ke posko agar keberadaan kamu tercatat.',
        'Jaga kebersihan dan air minum, terutama untuk anak kecil.',
        'Jangan kembali ke rumah sebelum otoritas menyatakan aman.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Panduan evakuasi'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          for (final b in _blocks) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Row(
                children: [
                  Icon(b.icon, color: b.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      b.title,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  for (var i = 0; i < b.items.length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 11,
                            backgroundColor: b.color.withValues(alpha: 0.16),
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: b.color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              b.items[i],
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
            message: 'Panduan umum. Jalur dan titik kumpul resmi ditentukan pemerintah daerah di wilayah kamu.',
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Siapkan tas siaga',
            icon: Icons.backpack_outlined,
            onPressed: () =>
                Navigator.pushNamed(context, RouteNames.preparedness),
          ),
        ],
      ),
    );
  }
}
