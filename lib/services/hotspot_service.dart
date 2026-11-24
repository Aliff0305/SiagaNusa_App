import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/models/hotspot_model.dart';
import 'package:siaganusa/services/api_service.dart';

class HotspotService {
  Future<List<HotspotModel>> fetch() async {
    if (!ApiConstants.useMock) {
      // Format Sipongi belum diverifikasi. Sesuaikan parser saat endpoint jelas.
      final body = await ApiService.instance.get(ApiConstants.hotspots);
      return ApiService.instance.asList(body).map(_fromJson).toList();
    }
    await Future.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    // DATA CONTOH untuk pengembangan UI.
    HotspotModel h(
      String id,
      String prov,
      String reg,
      double lat,
      double lng,
      int conf,
      int hoursAgo,
      String sat,
    ) => HotspotModel(
      id: id,
      province: prov,
      regency: reg,
      latitude: lat,
      longitude: lng,
      confidence: conf,
      detectedAt: now.subtract(Duration(hours: hoursAgo)),
      satellite: sat,
    );
    return [
      h('h1', 'Riau', 'Pelalawan', 0.35, 102.0, 88, 2, 'Terra/Aqua MODIS'),
      h('h2', 'Riau', 'Rokan Hilir', 1.9, 100.9, 72, 2, 'NOAA-20 VIIRS'),
      h(
        'h3',
        'Kalimantan Barat',
        'Ketapang',
        -1.8,
        110.2,
        91,
        3,
        'Terra/Aqua MODIS',
      ),
      h(
        'h4',
        'Kalimantan Tengah',
        'Kotawaringin Timur',
        -2.3,
        112.6,
        64,
        4,
        'Suomi NPP VIIRS',
      ),
      h(
        'h5',
        'Sumatera Selatan',
        'Ogan Komering Ilir',
        -3.4,
        105.3,
        45,
        5,
        'NOAA-20 VIIRS',
      ),
      h('h6', 'Jambi', 'Muaro Jambi', -1.6, 103.6, 83, 6, 'Terra/Aqua MODIS'),
      h(
        'h7',
        'Kalimantan Timur',
        'Kutai Kartanegara',
        -0.5,
        116.9,
        38,
        7,
        'Suomi NPP VIIRS',
      ),
    ];
  }

  HotspotModel _fromJson(Map<String, dynamic> j) => HotspotModel(
    id: '${j['id']}',
    province: '${j['province'] ?? '-'}',
    regency: '${j['regency'] ?? '-'}',
    latitude: double.tryParse('${j['latitude']}') ?? 0,
    longitude: double.tryParse('${j['longitude']}') ?? 0,
    confidence: int.tryParse('${j['confidence']}') ?? 0,
    detectedAt: DateTime.tryParse('${j['detected_at']}') ?? DateTime.now(),
    satellite: '${j['satellite'] ?? '-'}',
  );
}
