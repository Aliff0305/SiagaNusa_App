import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/models/notification_model.dart';
import 'package:siaganusa/services/api_service.dart';

class NotificationService {
  Future<List<NotificationModel>> fetch() async {
    if (!ApiConstants.useMock) {
      final res = await ApiService.instance.get(ApiConstants.notifications);
      final list = (res is Map ? res['data'] : res) as List? ?? [];
      return list
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    await Future.delayed(const Duration(milliseconds: 400));
    final now = DateTime.now();
    // DATA CONTOH. Nanti diganti dari backend / push notification.
    return [
      NotificationModel(
        id: 'n1',
        title: 'Gempa M5.4 terdeteksi di selatan Malang',
        body: 'BMKG mencatat gempa M5.4 pada kedalaman 10 km. Tidak berpotensi tsunami. Getaran dirasakan di Malang, Blitar, dan Surabaya.',
        type: DisasterType.earthquake,
        severity: Severity.moderate,
        time: now.subtract(const Duration(minutes: 35)),
        source: 'BMKG',
      ),
      NotificationModel(
        id: 'n2',
        title: 'Waspada tsunami di pesisir Maluku Tengah',
        body: 'Gempa M6.3 di Laut Maluku berpotensi tsunami. Warga pesisir diminta menjauhi pantai dan menunggu pembaruan resmi BMKG.',
        type: DisasterType.tsunami,
        severity: Severity.high,
        time: now.subtract(const Duration(hours: 5)),
        source: 'InaTEWS BMKG',
      ),
      NotificationModel(
        id: 'n3',
        title: 'Titik panas meningkat di Riau',
        body: 'Sipongi mendeteksi 2 titik panas dengan tingkat kepercayaan tinggi di Pelalawan dan Rokan Hilir. Perlu verifikasi lapangan.',
        type: DisasterType.wildfire,
        severity: Severity.moderate,
        time: now.subtract(const Duration(hours: 8)),
        source: 'Sipongi Gakkum KLHK',
        isRead: true,
      ),
      NotificationModel(
        id: 'n4',
        title: 'Gempa M4.6 di Padang',
        body: 'Gempa dirasakan ringan di Padang Pariaman. Tidak ada laporan kerusakan dalam data resmi.',
        type: DisasterType.earthquake,
        severity: Severity.low,
        time: now.subtract(const Duration(hours: 11)),
        source: 'BMKG',
        isRead: true,
      ),
    ];
  }

  Future<void> markAsRead(String id) async {
    if (ApiConstants.useMock) return;
    await ApiService.instance.patch('${ApiConstants.notifications}/$id/read');
  }
}
