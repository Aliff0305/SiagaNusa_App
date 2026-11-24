import 'package:flutter/foundation.dart';
import 'package:siaganusa/models/campaign_model.dart';
import 'package:siaganusa/models/donation_model.dart';
import 'package:siaganusa/services/donation_service.dart';

class DonationProvider extends ChangeNotifier {
  final DonationService _service = DonationService();

  List<CampaignModel> _campaigns = [];
  List<DonationModel> _history = [];
  bool _loading = false;
  bool _loaded = false;
  bool _paying = false;

  List<CampaignModel> get campaigns => _campaigns;
  List<DonationModel> get history => _history;
  bool get isLoading => _loading;
  bool get isPaying => _paying;
  double get totalDonated => _history.fold(0, (s, d) => s + d.amount);

  CampaignModel? byId(String id) {
    for (final c in _campaigns) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> load({bool force = false}) async {
    if (_loading || (_loaded && !force)) return;
    _loading = true;
    notifyListeners();
    _campaigns = await _service.fetchCampaigns();
    _history = await _service.fetchHistory();
    _loaded = true;
    _loading = false;
    notifyListeners();
  }

  Future<DonationModel> donate({
    required CampaignModel campaign,
    required double amount,
    required String method,
    required bool anonymous,
  }) async {
    _paying = true;
    notifyListeners();
    final d = await _service.donate(
      campaign: campaign,
      amount: amount,
      method: method,
      anonymous: anonymous,
    );
    _campaigns = [
      for (final c in _campaigns)
        c.id == campaign.id ? c.withDonation(amount) : c,
    ];
    _history = await _service.fetchHistory();
    _paying = false;
    notifyListeners();
    return d;
  }
}
