import 'package:siaganusa/models/disaster_model.dart';

class HotspotModel {
  final String id;
  final String province;
  final String regency;
  final double latitude;
  final double longitude;
  final int confidence; // persen (0-100)
  final DateTime detectedAt;
  final String satellite;

  const HotspotModel({
    required this.id,
    required this.province,
    required this.regency,
    required this.latitude,
    required this.longitude,
    required this.confidence,
    required this.detectedAt,
    required this.satellite,
  });

  Severity get severity {
    if (confidence >= 80) return Severity.high;
    if (confidence >= 50) return Severity.moderate;
    return Severity.low;
  }

  String get confidenceLabel => confidence >= 80
      ? 'Tinggi'
      : confidence >= 50
      ? 'Sedang'
      : 'Rendah';

  DisasterModel toDisaster() => DisasterModel(
    id: 'hs-$id',
    type: DisasterType.wildfire,
    title: 'Titik panas $regency',
    location: '$regency, $province',
    latitude: latitude,
    longitude: longitude,
    time: detectedAt,
    severity: severity,
    summary:
        'Titik panas terdeteksi satelit $satellite dengan tingkat kepercayaan $confidence% ($confidenceLabel).',
    hotspot: this,
  );
}
