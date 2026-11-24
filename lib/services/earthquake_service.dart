import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/models/earthquake_model.dart';
import 'package:siaganusa/services/api_service.dart';

class EarthquakeService {
  Future<List<EarthquakeModel>> fetch() async {
    if (!ApiConstants.useMock) {
      final body = await ApiService.instance.get(ApiConstants.earthquakes);
      return ApiService.instance
          .asList(body)
          .map(EarthquakeModel.fromBmkgJson)
          .toList();
    }
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    // DATA CONTOH untuk pengembangan UI, bukan kejadian nyata.
    return [
      EarthquakeModel(
        id: 'm1',
        dateTime: now.subtract(const Duration(minutes: 38)),
        latitude: -8.43,
        longitude: 112.25,
        magnitude: 5.4,
        depthKm: 10,
        region: 'Pusat gempa di laut 62 km barat daya Malang',
        potential: 'Tidak berpotensi tsunami',
        felt: 'III-IV Malang, III Blitar, II-III Surabaya',
      ),
      EarthquakeModel(
        id: 'm2',
        dateTime: now.subtract(const Duration(hours: 5, minutes: 12)),
        latitude: -3.32,
        longitude: 128.1,
        magnitude: 6.3,
        depthKm: 28,
        region: 'Pusat gempa di laut 74 km barat laut Maluku Tengah',
        potential: 'Berpotensi tsunami, pantau informasi BMKG',
        felt: 'IV Ambon, III Seram Bagian Barat',
      ),
      EarthquakeModel(
        id: 'm3',
        dateTime: now.subtract(const Duration(hours: 11)),
        latitude: -0.91,
        longitude: 99.8,
        magnitude: 4.6,
        depthKm: 54,
        region: 'Pusat gempa di darat 18 km timur laut Padang',
        potential: 'Tidak berpotensi tsunami',
        felt: 'III Padang Pariaman',
      ),
      EarthquakeModel(
        id: 'm4',
        dateTime: now.subtract(const Duration(days: 1, hours: 6)),
        latitude: 1.52,
        longitude: 126.7,
        magnitude: 5.1,
        depthKm: 120,
        region: 'Pusat gempa di laut 90 km timur laut Talaud',
        potential: 'Tidak berpotensi tsunami',
        felt: 'II-III Melonguane',
      ),
      EarthquakeModel(
        id: 'm5',
        dateTime: now.subtract(const Duration(days: 2, hours: 2)),
        latitude: -10.1,
        longitude: 123.9,
        magnitude: 3.9,
        depthKm: 15,
        region: 'Pusat gempa di darat 12 km selatan Kupang',
        potential: 'Tidak berpotensi tsunami',
        felt: 'II Kupang',
      ),
    ];
  }
}
