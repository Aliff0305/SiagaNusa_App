import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:siaganusa/core/routes/route_names.dart';
import 'package:siaganusa/core/utils/helpers.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/providers/disaster_provider.dart';
import 'package:siaganusa/widgets/disaster_card.dart';
import 'package:siaganusa/widgets/error_widget.dart';

class DisasterMapScreen extends StatefulWidget {
  const DisasterMapScreen({super.key});

  @override
  State<DisasterMapScreen> createState() => _DisasterMapScreenState();
}

class _DisasterMapScreenState extends State<DisasterMapScreen> {
  final MapController _controller = MapController();

  void _showSheet(DisasterModel d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DisasterCard(disaster: d),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushNamed(
                    context,
                    RouteNames.disasterDetail,
                    arguments: d,
                  );
                },
                child: const Text('Lihat detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DisasterProvider>();

    if (p.state == LoadState.error) {
      return SafeArea(
        child: AppErrorWidget(
          message: p.error ?? 'Terjadi kesalahan.',
          onRetry: () => p.load(force: true),
        ),
      );
    }

    final items = p.filtered;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: const MapOptions(
            initialCenter: LatLng(-2.5, 118),
            initialZoom: 4.4,
            minZoom: 3,
            maxZoom: 16,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'id.siaganusa.siaganusa',
            ),
            MarkerLayer(
              markers: [
                for (final d in items)
                  Marker(
                    point: LatLng(d.latitude, d.longitude),
                    width: 46,
                    height: 46,
                    child: GestureDetector(
                      onTap: () => _showSheet(d),
                      child: MapMarker(
                        color: Helpers.typeColor(d.type),
                        icon: Helpers.typeIcon(d.type),
                        label: d.earthquake?.magnitude.toStringAsFixed(1),
                      ),
                    ),
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('© OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(child: MapFilterBar()),
        ),
        if (p.isLoading)
          const Positioned.fill(
            child: IgnorePointer(
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.small(
            heroTag: 'map_recenter',
            tooltip: 'Kembali ke Indonesia',
            onPressed: () => _controller.move(const LatLng(-2.5, 118), 4.4),
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}

class MapMarker extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String? label;

  const MapMarker({
    super.key,
    required this.color,
    required this.icon,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: label != null
          ? Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            )
          : Icon(icon, color: Colors.white, size: 22),
    );
  }
}

class MapFilterBar extends StatelessWidget {
  const MapFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DisasterProvider>();
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          for (final type in DisasterType.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: p.activeFilter.contains(type),
                onSelected: (_) => p.toggleFilter(type),
                avatar: Icon(
                  Helpers.typeIcon(type),
                  size: 18,
                  color: p.activeFilter.contains(type)
                      ? Colors.white
                      : Helpers.typeColor(type),
                ),
                label: Text('${type.label} (${p.byType(type).length})'),
                showCheckmark: false,
                selectedColor: Helpers.typeColor(type),
                backgroundColor: Theme.of(context).colorScheme.surface,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: p.activeFilter.contains(type)
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
