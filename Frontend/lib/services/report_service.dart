import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/models/report_model.dart';
import 'package:siaganusa/services/api_service.dart';

class ReportService {
  final List<ReportModel> _store = [
    ReportModel(
      id: 'r1',
      category: 'Kerusakan bangunan',
      location: 'Kec. Lowokwaru, Malang',
      description: 'Retakan di dinding ruko setelah gempa tadi pagi.',
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      status: ReportStatus.verified,
      note: 'Sudah diteruskan ke BPBD Kota Malang.',
    ),
    ReportModel(
      id: 'r2',
      category: 'Asap / kebakaran lahan',
      location: 'Desa Sungai Ara, Pelalawan',
      description: 'Terlihat asap tebal dari arah kebun sejak sore.',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: ReportStatus.verifying,
    ),
  ];

  Future<List<ReportModel>> fetch() async {
    if (ApiConstants.useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      return List.unmodifiable(_store);
    }
    final res = await ApiService.instance.get(ApiConstants.reports);
    final list = (res is Map ? res['data'] : res) as List? ?? [];
    return list
        .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ReportModel> submit({
    required String category,
    required String location,
    required String description,
    String? photoName,
  }) async {
    if (ApiConstants.useMock) {
      await Future.delayed(const Duration(milliseconds: 900));
      final report = ReportModel(
        id: 'r${DateTime.now().millisecondsSinceEpoch}',
        category: category,
        location: location,
        description: description,
        photoName: photoName,
        createdAt: DateTime.now(),
        status: ReportStatus.pending,
      );
      _store.insert(0, report);
      return report;
    }
    final res = await ApiService.instance.post(
      ApiConstants.reports,
      data: {
        'category': category,
        'location': location,
        'description': description,
        if (photoName != null) 'photo_name': photoName,
      },
    );
    final data = (res is Map && res['data'] != null) ? res['data'] : res;
    return ReportModel.fromJson(data as Map<String, dynamic>);
  }
}
