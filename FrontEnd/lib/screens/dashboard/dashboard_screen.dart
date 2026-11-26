import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/tsunami_model.dart';
import 'package:siaganusa/providers/auth_provider.dart';
import 'package:siaganusa/providers/dashboard_provider.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/providers/notification_provider.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/disaster_card.dart';
import 'package:siaganusa/widgets/error_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _refresh(BuildContext context) async {
    await Future.wait([
      context.read<DisasterProvider>().load(force: true),
      context.read<NotificationProvider>().load(force: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final disasters = context.watch<DisasterProvider>();
    final dashboard = context.read<DashboardProvider>();
    final loaded = disasters.state == LoadState.loaded;
    final summary = loaded ? dashboard.summarize(disasters) : null;

    return RefreshIndicator(
      edgeOffset: 120,
      onRefresh: () => _refresh(context),
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          DashboardHeader(
            summary: summary,
            loading: disasters.isLoading && !loaded,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (disasters.state == LoadState.error)
                  SizedBox(
                    height: 320,
                    child: AppErrorWidget(
                      message: disasters.error ?? 'Terjadi kesalahan.',
                      onRetry: () => disasters.load(force: true),
                    ),
                  )
                else if (summary != null) ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.vibration,
                          color: AppColors.earthquake,
                          value: '${summary.earthquakeCount}',
                          label: 'Gempa 24 jam',
                          onTap: () {
                            final q = disasters.latestEarthquake;
                            if (q != null) {
                              Navigator.pushNamed(
                                context,
                                RouteNames.disasterDetail,
                                arguments: q,
                              );
                            } else {
                              dashboard.setTab(1);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.tsunami,
                          color: AppColors.tsunami,
                          value: summary.tsunamiStatus == TsunamiStatus.none
                              ? 'Aman'
                              : summary.tsunamiStatus == TsunamiStatus.watch
                              ? 'Waspada'
                              : 'Peringatan',
                          label: 'Status tsunami',
                          onTap: () {
                            final t = disasters.all
                                .where((d) => d.type == DisasterType.tsunami)
                                .firstOrNull;
                            if (t != null) {
                              Navigator.pushNamed(
                                context,
                                RouteNames.disasterDetail,
                                arguments: t,
                              );
                            } else {
                              dashboard.setTab(1);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.local_fire_department,
                          color: AppColors.wildfire,
                          value: '${summary.hotspotCount}',
                          label: 'Titik panas',
                          onTap: () => dashboard.setTab(1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const QuickActions(),
                  if (disasters.latestEarthquake != null) ...[
                    const SectionHeader(title: 'Gempa terbaru'),
                    _LatestQuakeCard(disaster: disasters.latestEarthquake!),
                  ],
                  SectionHeader(
                    title: 'Kejadian terbaru',
                    actionLabel: 'Lihat peta',
                    onAction: () => dashboard.setTab(1),
                  ),
                  for (final d in disasters.all.take(5))
                    DisasterCard(
                      disaster: d,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.disasterDetail,
                        arguments: d,
                      ),
                    ),
                  const SizedBox(height: 8),
                  const InfoBanner(
                    message: 'Data bersumber dari BMKG, InaTEWS BMKG, dan Sipongi Gakkum KLHK. Data yang tampil saat ini masih contoh sampai backend terhubung.',
                  ),
                  const SizedBox(height: 24),
                ] else
                  const SizedBox(
                    height: 240,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestQuakeCard extends StatelessWidget {
  final DisasterModel disaster;
  const _LatestQuakeCard({required this.disaster});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final eq = disaster.earthquake!;
    final color = Helpers.typeColor(disaster.type);

    return AppCard(
      onTap: () => Navigator.pushNamed(
        context,
        RouteNames.disasterDetail,
        arguments: disaster,
      ),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Text(
                  eq.magnitude.toStringAsFixed(1),
                  style: t.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 6),
                Text('M', style: t.titleMedium?.copyWith(color: color)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kedalaman ${eq.depthKm.toStringAsFixed(0)} km',
                        style: t.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormatter.dateTime(eq.dateTime),
                        style: t.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eq.region,
                  style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      eq.hasTsunamiPotential
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      size: 18,
                      color: eq.hasTsunamiPotential
                          ? AppColors.danger
                          : AppColors.success,
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(eq.potential, style: t.bodySmall)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Sumber: BMKG',
                  style: t.labelSmall?.copyWith(
                    color: Theme.of(context).hintColor,
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

class DashboardHeader extends StatelessWidget {
  final DashboardSummary? summary;
  final bool loading;

  const DashboardHeader({
    super.key,
    required this.summary,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final user = context.watch<AuthProvider>().user;
    final unread = context.watch<NotificationProvider>().unreadCount;

    final level = summary?.level ?? AlertLevel.normal;
    final levelColor = switch (level) {
      AlertLevel.normal => const Color(0xFF69D08A),
      AlertLevel.waspada => const Color(0xFFFFC857),
      AlertLevel.siaga => const Color(0xFFFF7A70),
    };

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormatter.greeting(),
                        style: t.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      Text(
                        user?.name ?? 'Warga Nusantara',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Notifikasi',
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteNames.notifications),
                  icon: Badge(
                    isLabelVisible: unread > 0,
                    label: Text('$unread'),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: loading || summary == null
                  ? const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Memuat kondisi terbaru...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: levelColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                summary!.title,
                                style: t.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          summary!.message,
                          style: t.bodySmall?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ringkasan otomatis SiagaNusa dari data resmi, bukan status resmi pemerintah.',
                          style: t.labelSmall?.copyWith(color: Colors.white54),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_Action>[
      _Action(
        'Lapor',
        Icons.edit_note,
        AppColors.secondary,
        () => Navigator.pushNamed(context, RouteNames.report),
      ),
      _Action(
        'Kontak darurat',
        Icons.call_outlined,
        AppColors.danger,
        () => Navigator.pushNamed(context, RouteNames.emergencyContacts),
      ),
      _Action(
        'Tas siaga',
        Icons.backpack_outlined,
        AppColors.earthquake,
        () => Navigator.pushNamed(context, RouteNames.preparedness),
      ),
      _Action(
        'Donasi',
        Icons.volunteer_activism_outlined,
        AppColors.tsunami,
        () => context.read<DashboardProvider>().setTab(2),
      ),
    ];
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        for (final a in items)
          Expanded(
            child: InkWell(
              onTap: a.onTap,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: a.color.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(a.icon, color: a.color),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      a.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: t.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _Action(this.label, this.icon, this.color, this.onTap);
}
