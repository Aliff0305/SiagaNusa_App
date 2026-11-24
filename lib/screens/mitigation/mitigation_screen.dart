import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class MitigationScreen extends StatelessWidget {
  const MitigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Mitigasi dan keselamatan',
            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Persiapan sederhana yang dapat menyelamatkan nyawa.',
            style: t.bodyMedium,
          ),
          const SectionHeader(title: 'Panduan per bencana'),
          for (final g in MitigationData.guides)
            AppCard(
              margin: const EdgeInsets.only(bottom: 12),
              onTap: () => Navigator.pushNamed(
                context,
                RouteNames.mitigationDetail,
                arguments: g,
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: g.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(g.icon, color: g.color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          g.title,
                          style: t.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(g.subtitle, style: t.bodySmall),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          const SectionHeader(title: 'Persiapan'),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.backpack_outlined,
                  color: AppColors.secondary,
                  label: 'Tas siaga',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.preparedness),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Tile(
                  icon: Icons.directions_run,
                  color: AppColors.earthquake,
                  label: 'Panduan evakuasi',
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.evacuation),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Tile(
                  icon: Icons.call_outlined,
                  color: AppColors.danger,
                  label: 'Kontak darurat',
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.emergencyContacts,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Tile(
                  icon: Icons.edit_note,
                  color: AppColors.info,
                  label: 'Lapor kondisi',
                  onTap: () => Navigator.pushNamed(context, RouteNames.report),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _Tile({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class MitigationStep {
  final String phase;
  final List<String> actions;
  const MitigationStep(this.phase, this.actions);
}

class MitigationGuide {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<MitigationStep> steps;

  const MitigationGuide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.steps,
  });
}

/// Panduan umum. Konten final sebaiknya divalidasi dengan materi resmi BNPB/BMKG.
class MitigationData {
  MitigationData._();

  static const List<MitigationGuide> guides = [
    MitigationGuide(
      id: 'gempa',
      title: 'Gempa bumi',
      subtitle: 'Sebelum, saat, dan sesudah gempa',
      icon: Icons.vibration,
      color: AppColors.earthquake,
      steps: [
        MitigationStep('Sebelum gempa', [
          'Kenali jalur evakuasi dan titik kumpul di rumah, kantor, dan sekolah.',
          'Pasang rak dan lemari tinggi agar tidak mudah roboh.',
          'Siapkan tas siaga dan simpan nomor darurat.',
          'Latih keluarga melakukan "merunduk, lindungi kepala, bertahan".',
        ]),
        MitigationStep('Saat gempa', [
          'Merunduk, lindungi kepala dan leher, dan berpegangan pada meja yang kokoh.',
          'Jauhi kaca, lemari, dan benda yang dapat jatuh.',
          'Di luar ruangan, menjauh dari gedung, tiang, dan kabel listrik.',
          'Di pesisir, segera menuju tempat tinggi setelah getaran berhenti.',
        ]),
        MitigationStep('Sesudah gempa', [
          'Periksa diri dan sekitar, beri pertolongan pertama bila perlu.',
          'Matikan listrik dan gas bila ada kebocoran atau kerusakan.',
          'Waspadai gempa susulan, jangan masuk bangunan yang retak berat.',
          'Ikuti informasi resmi BMKG dan BPBD.',
        ]),
      ],
    ),
    MitigationGuide(
      id: 'tsunami',
      title: 'Tsunami',
      subtitle: 'Kenali tanda dan langkah evakuasi',
      icon: Icons.tsunami,
      color: AppColors.tsunami,
      steps: [
        MitigationStep('Kenali tanda', [
          'Gempa kuat atau berlangsung lama di wilayah pesisir.',
          'Air laut surut mendadak atau terdengar gemuruh dari laut.',
          'Sirene atau pengumuman resmi peringatan tsunami.',
        ]),
        MitigationStep('Saat peringatan', [
          'Segera menjauh dari pantai menuju tempat tinggi atau gedung evakuasi.',
          'Jangan menunggu gelombang terlihat.',
          'Utamakan berjalan kaki bila jalur macet.',
          'Tetap di tempat aman sampai BMKG menyatakan peringatan berakhir.',
        ]),
        MitigationStep('Sesudah', [
          'Gelombang dapat datang berkali-kali. Jangan kembali terlalu cepat.',
          'Hindari air banjir yang mungkin tercemar atau terhubung listrik.',
        ]),
      ],
    ),
    MitigationGuide(
      id: 'karhutla',
      title: 'Kebakaran hutan dan lahan',
      subtitle: 'Kesehatan dan pencegahan',
      icon: Icons.local_fire_department,
      color: AppColors.wildfire,
      steps: [
        MitigationStep('Pencegahan', [
          'Jangan membakar lahan atau sampah di area kering.',
          'Laporkan api atau asap mencurigakan ke pihak berwenang.',
          'Dukung pengelolaan lahan gambut agar tetap basah.',
        ]),
        MitigationStep('Saat berasap', [
          'Gunakan masker N95/KN95 saat beraktivitas di luar.',
          'Tutup jendela, kurangi aktivitas di luar ruangan.',
          'Perbanyak minum air dan lindungi anak, lansia, dan penderita asma.',
        ]),
        MitigationStep('Bila sesak atau sakit', [
          'Segera ke fasilitas kesehatan bila sesak napas, batuk berat, atau mata sangat perih.',
          'Ikuti imbauan BPBD dan dinas kesehatan setempat.',
        ]),
      ],
    ),
  ];
}
