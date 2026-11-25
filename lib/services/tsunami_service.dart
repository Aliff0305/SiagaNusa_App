import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/models/tsunami_model.dart';
import 'package:siaganusa/services/api_service.dart';

class TsunamiService {
  Future<List<TsunamiModel>> fetch() async {
    if (!ApiConstants.useMock) {
      final body = await ApiService.instance.get(ApiConstants.tsunamis);
      final data = body is Map ? (body['data'] ?? body) : body;
      if (data is Map && data['Infogempa'] is Map) {
        final gempa = (data['Infogempa'] as Map)['gempa'];
        if (gempa is List) {
          return gempa.whereType<Map<String, dynamic>>().map(_fromJson).toList();
        }
        if (gempa is Map<String, dynamic>) {
          return [_fromJson(gempa)];
        }
      }
      return ApiService.instance.asList(body).map(_fromJson).toList();
    }
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    // DATA CONTOH untuk pengembangan UI.
    return [
      TsunamiModel(
        id: 't1',
        status: TsunamiStatus.watch,
        isActive: true,
        issuedAt: now.subtract(const Duration(hours: 5)),
        latitude: -3.32,
        longitude: 128.1,
        origin: 'Laut Maluku Tengah',
        regions: [
          'Pesisir Maluku Tengah',
          'Pesisir Seram Bagian Barat',
          'Kota Ambon',
        ],
        message: 'Gempa M6.3 berpotensi tsunami. Warga pesisir diminta menjauhi pantai sambil menunggu pembaruan resmi BMKG.',
      ),
      TsunamiModel(
        id: 't2',
        status: TsunamiStatus.none,
        isActive: false,
        issuedAt: now.subtract(const Duration(minutes: 36)),
        latitude: -8.43,
        longitude: 112.25,
        origin: 'Laut selatan Malang',
        regions: [],
        message: 'Gempa M5.4 di selatan Jawa Timur tidak berpotensi tsunami.',
      ),
    ];
  }

  TsunamiModel _fromJson(Map<String, dynamic> j) => TsunamiModel(
    id: '${j['id']}',
    status: TsunamiStatus.values.firstWhere(
      (s) => s.name == '${j['status']}',
      orElse: () => TsunamiStatus.none,
    ),
    isActive: j['is_active'] == true,
    issuedAt: DateTime.tryParse('${j['issued_at']}') ?? DateTime.now(),
    latitude: double.tryParse('${j['latitude']}') ?? 0,
    longitude: double.tryParse('${j['longitude']}') ?? 0,
    origin: '${j['origin'] ?? '-'}',
    regions: (j['regions'] as List? ?? []).map((e) => '$e').toList(),
    message: '${j['message'] ?? ''}',
  );
}
