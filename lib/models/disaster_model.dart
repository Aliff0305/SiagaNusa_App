import 'package:siaganusa/core/utils/date_formatter.dart';
import 'package:siaganusa/models/earthquake_model.dart';
import 'package:siaganusa/models/hotspot_model.dart';
import 'package:siaganusa/models/tsunami_model.dart';

enum DisasterType { earthquake, tsunami, wildfire }

extension DisasterTypeX on DisasterType {
  String get label => switch (this) {
    DisasterType.earthquake => 'Gempa bumi',
    DisasterType.tsunami => 'Tsunami',
    DisasterType.wildfire => 'Karhutla',
  };

  String get officialSource => switch (this) {
    DisasterType.earthquake => 'BMKG',
    DisasterType.tsunami => 'InaTEWS BMKG',
    DisasterType.wildfire => 'Sipongi Gakkum KLHK',
  };
}

enum Severity { low, moderate, high, critical }

extension SeverityX on Severity {
  String get label => switch (this) {
    Severity.low => 'Rendah',
    Severity.moderate => 'Sedang',
    Severity.high => 'Tinggi',
    Severity.critical => 'Kritis',
  };
}

/// Bentuk seragam untuk semua jenis kejadian (dipakai peta, daftar, dan detail).
class DisasterModel {
  final String id;
  final DisasterType type;
  final String title;
  final String location;
  final double latitude;
  final double longitude;
  final DateTime time;
  final Severity severity;
  final String summary;
  final EarthquakeModel? earthquake;
  final TsunamiModel? tsunami;
  final HotspotModel? hotspot;

  const DisasterModel({
    required this.id,
    required this.type,
    required this.title,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.time,
    required this.severity,
    required this.summary,
    this.earthquake,
    this.tsunami,
    this.hotspot,
  });

  String get source => type.officialSource;

  /// Baris data resmi untuk halaman detail.
  List<MapEntry<String, String>> get detailRows {
    final rows = <MapEntry<String, String>>[
      MapEntry('Waktu', DateFormatter.dateTime(time)),
      MapEntry('Lokasi', location),
      MapEntry(
        'Koordinat',
        '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}',
      ),
    ];
    final eq = earthquake;
    if (eq != null) {
      rows.addAll([
        MapEntry('Magnitudo', eq.magnitude.toStringAsFixed(1)),
        MapEntry('Kedalaman', '${eq.depthKm.toStringAsFixed(0)} km'),
        MapEntry('Potensi', eq.potential),
        MapEntry('Dirasakan', eq.felt),
      ]);
    }
    final ts = tsunami;
    if (ts != null) {
      rows.addAll([
        MapEntry('Status', ts.status.label),
        MapEntry('Peringatan aktif', ts.isActive ? 'Ya' : 'Tidak'),
      ]);
    }
    final hs = hotspot;
    if (hs != null) {
      rows.addAll([
        MapEntry('Satelit', hs.satellite),
        MapEntry('Kepercayaan', '${hs.confidence}% (${hs.confidenceLabel})'),
      ]);
    }
    return rows;
  }
}

class RiskFactor {
  final String name;
  final double value; // 0..1
  final String note;
  const RiskFactor(this.name, this.value, this.note);
}

/// Hasil analisis sistem (BUKAN data resmi).
class ImpactAnalysis {
  final int riskScore; // 0..100
  final Severity riskLevel;
  final List<RiskFactor> factors;
  final List<String> potentialImpacts;
  final List<String> causes;
  final List<String> recommendations;
  final String disclaimer;

  const ImpactAnalysis({
    required this.riskScore,
    required this.riskLevel,
    required this.factors,
    required this.potentialImpacts,
    required this.causes,
    required this.recommendations,
    required this.disclaimer,
  });
}
