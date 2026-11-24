import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:siaganusa/core/constants/app_colors.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/screens/disaster/earthquake_detail_screen.dart';
import 'package:siaganusa/screens/disaster/hotspot_detail_screen.dart';
import 'package:siaganusa/screens/disaster/tsunami_detail_screen.dart';
import 'package:siaganusa/widgets/common_widgets.dart';
import 'package:siaganusa/widgets/disaster_badge.dart';

/// Pintu masuk halaman detail: memilih layar sesuai jenis bencana.
class DisasterDetailScreen extends StatelessWidget {
  final DisasterModel disaster;
  const DisasterDetailScreen({super.key, required this.disaster});

  @override
  Widget build(BuildContext context) => switch (disaster.type) {
    DisasterType.earthquake => EarthquakeDetailScreen(disaster: disaster),
    DisasterType.tsunami => TsunamiDetailScreen(disaster: disaster),
    DisasterType.wildfire => HotspotDetailScreen(disaster: disaster),
  };
}

/// Kerangka halaman detail yang dipakai gempa, tsunami, dan hotspot.
class DisasterDetailScaffold extends StatelessWidget {
  final DisasterModel disaster;
  final List<Widget> topChildren;
  final List<Widget> extraChildren;

  const DisasterDetailScaffold({
    super.key,
    required this.disaster,
    this.topChildren = const [],
    this.extraChildren = const [],
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final color = Helpers.typeColor(disaster.type);
    final point = LatLng(disaster.latitude, disaster.longitude);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 210,
            backgroundColor: color,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 56,
                bottom: 14,
                right: 16,
              ),
              title: Text(
                disaster.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, Color.lerp(color, Colors.black, 0.45)!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 56),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Helpers.typeIcon(disaster.type),
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        DisasterBadge(
                          severity: disaster.severity,
                          onDark: true,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            DateFormatter.ago(disaster.time),
                            style: t.bodySmall?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SourceTag(kind: InfoKind.official, source: disaster.source),
                const SizedBox(height: 16),
                ...topChildren,
                Text(disaster.summary, style: t.bodyLarge),
                const SectionHeader(title: 'Detail kejadian'),
                AppCard(
                  child: Column(
                    children: [
                      for (var i = 0; i < disaster.detailRows.length; i++) ...[
                        if (i > 0) const Divider(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 110,
                              child: Text(
                                disaster.detailRows[i].key,
                                style: t.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                disaster.detailRows[i].value,
                                style: t.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SectionHeader(title: 'Lokasi'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 190,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: point,
                        initialZoom: 6,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'id.siaganusa.siaganusa',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: point,
                              width: 44,
                              height: 44,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: Icon(
                                  Helpers.typeIcon(disaster.type),
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution(
                              '© OpenStreetMap contributors',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ...extraChildren,
                const SectionHeader(title: 'Analisis dan tindakan'),
                const SourceTag(kind: InfoKind.analysis, showHint: false),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Lihat analisis dampak',
                  icon: Icons.analytics_outlined,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.impactAnalysis,
                    arguments: disaster,
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Lihat tingkat risiko',
                  icon: Icons.speed,
                  outlined: true,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.riskAnalysis,
                    arguments: disaster,
                  ),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: 'Laporkan kondisi di lapangan',
                  icon: Icons.edit_note,
                  outlined: true,
                  color: AppColors.secondary,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    RouteNames.createReport,
                    arguments: disaster,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
