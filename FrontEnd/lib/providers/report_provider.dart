import 'package:flutter/foundation.dart';
import 'package:siaganusa/models/report_model.dart';
import 'package:siaganusa/services/report_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportService _service = ReportService();

  List<ReportModel> _reports = [];
  bool _loading = false;
  bool _submitting = false;
  bool _loaded = false;

  List<ReportModel> get reports => _reports;
  bool get isLoading => _loading;
  bool get isSubmitting => _submitting;

  Future<void> load({bool force = false}) async {
    if (_loading || (_loaded && !force)) return;
    _loading = true;
    notifyListeners();
    _reports = await _service.fetch();
    _loaded = true;
    _loading = false;
    notifyListeners();
  }

  Future<void> submit({
    required String category,
    required String location,
    required String description,
    String? photoName,
  }) async {
    _submitting = true;
    notifyListeners();
    await _service.submit(
      category: category,
      location: location,
      description: description,
      photoName: photoName,
    );
    _reports = await _service.fetch();
    _loaded = true;
    _submitting = false;
    notifyListeners();
  }
}
