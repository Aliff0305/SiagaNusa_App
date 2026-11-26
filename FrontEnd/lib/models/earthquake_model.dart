import 'package:siaganusa/models/disaster_model.dart';

class EarthquakeModel {
  final String id;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final double magnitude;
  final double depthKm;
  final String region;
  final String potential;
  final String felt;

  const EarthquakeModel({
    required this.id,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.magnitude,
    required this.depthKm,
    required this.region,
    required this.potential,
    required this.felt,
  });

  /// Parser untuk respons BMKG. Nama field di bawah adalah DUGAAN berdasarkan
  /// contoh data terbuka BMKG dan HARUS diverifikasi ke
  /// https://data.bmkg.go.id/gempabumi/ sebelum dipakai (ApiConstants.useMock = false).
  factory EarthquakeModel.fromBmkgJson(Map<String, dynamic> j) {
    final coords = (j['Coordinates'] as String? ?? '0,0').split(',');
    return EarthquakeModel(
      id: (j['DateTime'] ?? DateTime.now().toIso8601String()).toString(),
      dateTime:
          DateTime.tryParse('${j['DateTime']}')?.toLocal() ?? DateTime.now(),
      latitude: double.tryParse(coords.first.trim()) ?? 0,
      longitude: double.tryParse(coords.last.trim()) ?? 0,
      magnitude: double.tryParse('${j['Magnitude']}') ?? 0,
      depthKm:
          double.tryParse(
            '${j['Kedalaman']}'.replaceAll(RegExp(r'[^0-9.]'), ''),
          ) ??
          0,
      region: '${j['Wilayah'] ?? '-'}',
      potential: '${j['Potensi'] ?? '-'}',
      felt: '${j['Dirasakan'] ?? '-'}',
    );
  }

  Severity get severity {
    if (magnitude >= 7) return Severity.critical;
    if (magnitude >= 6) return Severity.high;
    if (magnitude >= 5) return Severity.moderate;
    return Severity.low;
  }

  bool get hasTsunamiPotential =>
      !potential.toLowerCase().contains('tidak berpotensi');

  DisasterModel toDisaster() => DisasterModel(
    id: 'eq-$id',
    type: DisasterType.earthquake,
    title: 'Gempa M${magnitude.toStringAsFixed(1)}',
    location: region,
    latitude: latitude,
    longitude: longitude,
    time: dateTime,
    severity: severity,
    summary:
        'Gempa magnitudo ${magnitude.toStringAsFixed(1)} pada kedalaman ${depthKm.toStringAsFixed(0)} km. $potential',
    earthquake: this,
  );
}
