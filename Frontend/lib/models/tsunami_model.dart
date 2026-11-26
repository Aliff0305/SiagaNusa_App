import 'package:siaganusa/models/disaster_model.dart';

enum TsunamiStatus { none, watch, warning }

extension TsunamiStatusX on TsunamiStatus {
  String get label => switch (this) {
    TsunamiStatus.none => 'Tidak berpotensi tsunami',
    TsunamiStatus.watch => 'Waspada tsunami',
    TsunamiStatus.warning => 'Peringatan tsunami',
  };
}

class TsunamiModel {
  final String id;
  final TsunamiStatus status;
  final bool isActive;
  final DateTime issuedAt;
  final double latitude;
  final double longitude;
  final String origin;
  final List<String> regions;
  final String message;

  const TsunamiModel({
    required this.id,
    required this.status,
    required this.isActive,
    required this.issuedAt,
    required this.latitude,
    required this.longitude,
    required this.origin,
    required this.regions,
    required this.message,
  });

  Severity get severity => switch (status) {
    TsunamiStatus.none => Severity.low,
    TsunamiStatus.watch => Severity.high,
    TsunamiStatus.warning => Severity.critical,
  };

  DisasterModel toDisaster() => DisasterModel(
    id: 'ts-$id',
    type: DisasterType.tsunami,
    title: status.label,
    location: origin,
    latitude: latitude,
    longitude: longitude,
    time: issuedAt,
    severity: severity,
    summary: message,
    tsunami: this,
  );
}
