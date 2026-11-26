import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/providers/auth_provider.dart';
import 'package:siaganusa/providers/dashboard_provider.dart';
import 'package:siaganusa/providers/donation_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu bisa masuk lagi kapan saja.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              minimumSize: const Size(100, 44),
              backgroundColor: AppColors.danger,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final nav = Navigator.of(context);
    context.read<DashboardProvider>().setTab(0);
    await context.read<AuthProvider>().logout();
    nav.pushNamedAndRemoveUntil(RouteNames.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final donation = context.watch<DonationProvider>();
    final t = Theme.of(context).textTheme;
    final user = auth.user;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Profil',
            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user?.initials ?? '?',
                    style: t.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: user == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Belum masuk',
                              style: t.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Masuk untuk berdonasi dan melapor.',
                              style: t.bodySmall,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: t.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(user.email, style: t.bodySmall),
                            if (user.city.isNotEmpty)
                              Text(user.city, style: t.bodySmall),
                          ],
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Helpers.rupiahCompact(donation.totalDonated),
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text('Total donasi', style: t.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${donation.history.length}',
                        style: t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text('Kali berdonasi', style: t.bodySmall),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SectionHeader(title: 'Aktivitas'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: const Text('Riwayat donasi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.donationHistory),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit_note),
                  title: const Text('Laporan saya'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.reportHistory),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications_none),
                  title: const Text('Riwayat peringatan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.notifications),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Akun'),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                if (user != null) ...[
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Ubah profil'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        Navigator.pushNamed(context, RouteNames.editProfile),
                  ),
                  const Divider(),
                ],
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Pengaturan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (user != null)
            AppButton(
              label: 'Keluar',
              icon: Icons.logout,
              outlined: true,
              color: AppColors.danger,
              onPressed: _logout,
            )
          else
            AppButton(
              label: 'Masuk atau daftar',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.login,
                (_) => false,
              ),
            ),
        ],
      ),
    );
  }
}
