import 'package:flutter/foundation.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/tsunami_model.dart';
import 'package:siaganusa/providers/disaster_provider.dart';

enum AlertLevel { normal, waspada, siaga }

class DashboardSummary {
  final AlertLevel level;
  final String title;
  final String message;
  final int earthquakeCount;
  final int hotspotCount;
  final TsunamiStatus tsunamiStatus;

  const DashboardSummary({
    required this.level,
    required this.title,
    required this.message,
    required this.earthquakeCount,
    required this.hotspotCount,
    required this.tsunamiStatus,
  });
}

class DashboardProvider extends ChangeNotifier {
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  void setTab(int i) {
    if (i == _tabIndex) return;
    _tabIndex = i;
    notifyListeners();
  }

  /// Ringkasan kondisi nasional dari data resmi. Tingkat kewaspadaan di sini
  /// adalah ANALISIS SISTEM sederhana, bukan status resmi pemerintah.
  DashboardSummary summarize(DisasterProvider d) {
    final tsunamis = d
        .byType(DisasterType.tsunami)
        .where((t) => t.tsunami!.isActive)
        .toList();
    final worst = tsunamis.isEmpty
        ? TsunamiStatus.none
        : tsunamis
              .map((t) => t.tsunami!.status)
              .reduce((a, b) => a.index >= b.index ? a : b);

    final dayAgo = DateTime.now().subtract(const Duration(hours: 24));
    final recentQuakes = d
        .byType(DisasterType.earthquake)
        .where((q) => q.time.isAfter(dayAgo))
        .toList();
    final strong = recentQuakes
        .where((q) => q.earthquake!.magnitude >= 5)
        .length;
    final highHotspots = d
        .byType(DisasterType.wildfire)
        .where((h) => h.hotspot!.confidence >= 80)
        .length;

    AlertLevel level = AlertLevel.normal;
    String title = 'Kondisi relatif normal';
    String msg =
        'Tidak ada peringatan tsunami aktif. Tetap siaga dan pantau informasi resmi.';

    if (worst == TsunamiStatus.warning) {
      level = AlertLevel.siaga;
      title = 'Peringatan tsunami aktif';
      msg =
          'Ada peringatan tsunami aktif. Ikuti arahan BMKG dan BPBD setempat.';
    } else if (worst == TsunamiStatus.watch) {
      level = AlertLevel.waspada;
      title = 'Waspada tsunami';
      msg = 'Ada status waspada tsunami di sebagian wilayah. Jauhi pantai bila berada di zona terdampak.';
    } else if (strong > 0 || highHotspots >= 3) {
      level = AlertLevel.waspada;
      title = 'Perlu waspada';
      msg =
          '$strong gempa M5+ dan $highHotspots titik panas berkepercayaan tinggi dalam data terbaru.';
    }

    return DashboardSummary(
      level: level,
      title: title,
      message: msg,
      earthquakeCount: recentQuakes.length,
      hotspotCount: d.byType(DisasterType.wildfire).length,
      tsunamiStatus: worst,
    );
  }
}
