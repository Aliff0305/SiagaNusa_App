import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_strings.dart';
import 'package:siaganusa/providers/theme_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Pengaturan lokal sementara. Push notification menyusul bersama backend.
  bool _earthquake = true;
  bool _tsunami = true;
  bool _wildfire = true;

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pengaturan'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        children: [
          const SectionHeader(title: 'Tampilan'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final entry in const {
                  ThemeMode.system: 'Ikuti sistem',
                  ThemeMode.light: 'Terang',
                  ThemeMode.dark: 'Gelap',
                }.entries)
                  ListTile(
                    leading: Icon(
                      theme.mode == entry.key
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: theme.mode == entry.key
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(entry.value),
                    onTap: () => theme.setMode(entry.key),
                  ),
              ],
            ),
          ),
          const SectionHeader(title: 'Jenis peringatan'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.vibration),
                  title: const Text('Gempa bumi'),
                  value: _earthquake,
                  onChanged: (v) => setState(() => _earthquake = v),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.tsunami),
                  title: const Text('Tsunami'),
                  value: _tsunami,
                  onChanged: (v) => setState(() => _tsunami = v),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.local_fire_department),
                  title: const Text('Karhutla'),
                  value: _wildfire,
                  onChanged: (v) => setState(() => _wildfire = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const InfoBanner(
            message: 'Pilihan ini belum mengirim notifikasi ke ponsel. Push notification akan ditambahkan setelah backend siap.',
          ),
          const SectionHeader(title: 'Tentang'),
          AppCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang SiagaNusa'),
              subtitle: const Text('Versi 0.1.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: AppStrings.appName,
                applicationVersion: '0.1.0',
                children: const [
                  Text(
                    'Sumber data: BMKG, InaTEWS BMKG, dan Sipongi Gakkum KLHK. Analisis dampak dan risiko dihitung sistem dan bukan pernyataan resmi pemerintah.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
