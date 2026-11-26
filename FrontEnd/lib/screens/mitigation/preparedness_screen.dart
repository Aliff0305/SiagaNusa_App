import 'package:flutter/material.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class PreparednessScreen extends StatefulWidget {
  const PreparednessScreen({super.key});

  @override
  State<PreparednessScreen> createState() => _PreparednessScreenState();
}

class _PreparednessScreenState extends State<PreparednessScreen> {
  static const Map<String, List<String>> _groups = {
    'Dokumen dan uang': [
      'Fotokopi KTP, KK, dan dokumen penting dalam plastik tahan air',
      'Uang tunai secukupnya',
      'Daftar nomor darurat keluarga',
    ],
    'Makanan dan minuman': [
      'Air minum untuk minimal 3 hari',
      'Makanan tahan lama dan siap makan',
      'Pembuka kaleng dan peralatan makan ringan',
    ],
    'Kesehatan': [
      'Obat pribadi dan P3K',
      'Masker (N95/KN95)',
      'Perlengkapan kebersihan dan sanitasi',
    ],
    'Perlengkapan': [
      'Senter dan baterai cadangan',
      'Power bank dan radio kecil',
      'Peluit',
      'Selimut atau jas hujan',
      'Pakaian ganti',
    ],
  };

  final Set<String> _checked = {};

  int get _total => _groups.values.fold(0, (s, l) => s + l.length);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final progress = _total == 0 ? 0.0 : _checked.length / _total;

    return Scaffold(
      appBar: CustomAppBar(title: 'Tas siaga'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_checked.length} dari $_total siap',
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    color: AppColors.secondary,
                    backgroundColor: AppColors.secondary.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final entry in _groups.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: Text(
                entry.key,
                style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  for (final item in entry.value)
                    CheckboxListTile(
                      value: _checked.contains(item),
                      onChanged: (v) => setState(() {
                        if (v == true) {
                          _checked.add(item);
                        } else {
                          _checked.remove(item);
                        }
                      }),
                      title: Text(item, style: t.bodyMedium),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          const InfoBanner(
            message: 'Centang hanya tersimpan selama halaman terbuka. Penyimpanan permanen bisa ditambahkan nanti.',
          ),
        ],
      ),
    );
  }
}
