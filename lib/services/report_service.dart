import 'package:siaganusa/models/report_model.dart';

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
    await Future.delayed(const Duration(milliseconds: 400));
    return List.unmodifiable(_store);
  }

  Future<ReportModel> submit({
    required String category,
    required String location,
    required String description,
    String? photoName,
  }) async {
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
}
