import 'package:flutter/foundation.dart';
import 'package:siaganusa/core/network/api_exception.dart';
import 'package:siaganusa/models/disaster_model.dart';
import 'package:siaganusa/services/disaster_service.dart';

enum LoadState { idle, loading, loaded, error }

class DisasterProvider extends ChangeNotifier {
  final DisasterService _service = DisasterService();

  LoadState _state = LoadState.idle;
  String? _error;
  List<DisasterModel> _all = [];
  final Set<DisasterType> _filter = {...DisasterType.values};

  LoadState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == LoadState.loading;
  List<DisasterModel> get all => _all;
  Set<DisasterType> get activeFilter => _filter;

  List<DisasterModel> get filtered =>
      _all.where((d) => _filter.contains(d.type)).toList();

  List<DisasterModel> byType(DisasterType t) =>
      _all.where((d) => d.type == t).toList();

  DisasterModel? get latestEarthquake {
    final l = byType(DisasterType.earthquake);
    return l.isEmpty ? null : l.first;
  }

  Future<void> load({bool force = false}) async {
    if (_state == LoadState.loading) return;
    if (_state == LoadState.loaded && !force) return;
    _state = LoadState.loading;
    _error = null;
    notifyListeners();
    try {
      final b = await _service.fetchAll();
      _all = [
        ...b.earthquakes.map((e) => e.toDisaster()),
        ...b.tsunamis.map((t) => t.toDisaster()),
        ...b.hotspots.map((h) => h.toDisaster()),
      ]..sort((a, b) => b.time.compareTo(a.time));
      _state = LoadState.loaded;
    } on ApiException catch (e) {
      _error = e.message;
      _state = LoadState.error;
    } catch (_) {
      _error = 'Gagal memuat data bencana.';
      _state = LoadState.error;
    }
    notifyListeners();
  }

  void toggleFilter(DisasterType t) {
    if (_filter.contains(t)) {
      if (_filter.length > 1) _filter.remove(t);
    } else {
      _filter.add(t);
    }
    notifyListeners();
  }

  ImpactAnalysis analysisFor(DisasterModel d) =>
      DisasterService.analyze(d, _all);
}
