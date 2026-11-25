import 'package:siaganusa/models/disaster_model.dart';

class CampaignUpdate {
  final DateTime date;
  final String text;
  const CampaignUpdate(this.date, this.text);
}

class FundAllocation {
  final String label;
  final double percent; // 0..100
  const FundAllocation(this.label, this.percent);
}

class CampaignModel {
  final String id;
  final String title;
  final String location;
  final DisasterType type;
  final String description;
  final String organizer;
  final double target;
  final double collected;
  final int donors;
  final DateTime deadline;
  final bool verified;
  final String verifiedBy;
  final List<CampaignUpdate> updates;
  final List<FundAllocation> allocation;

  const CampaignModel({
    required this.id,
    required this.title,
    required this.location,
    required this.type,
    required this.description,
    required this.organizer,
    required this.target,
    required this.collected,
    required this.donors,
    required this.deadline,
    required this.verified,
    required this.verifiedBy,
    this.updates = const [],
    this.allocation = const [],
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
    id: (json['id'] ?? '').toString(),
    title: (json['title'] ?? '').toString(),
    location: (json['location'] ?? '').toString(),
    type: DisasterType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => DisasterType.earthquake,
    ),
    description: (json['description'] ?? '').toString(),
    organizer: (json['organizer'] ?? '').toString(),
    target: double.tryParse((json['target'] ?? json['target_amount'] ?? 0).toString()) ?? 0,
    collected: double.tryParse((json['collected'] ?? json['collected_amount'] ?? 0).toString()) ?? 0,
    donors: int.tryParse((json['donors'] ?? 0).toString()) ?? 0,
    deadline: DateTime.tryParse((json['deadline'] ?? '').toString()) ?? DateTime.now(),
    verified: json['verified'] == true,
    verifiedBy: (json['verified_by'] ?? json['verifiedBy'] ?? '').toString(),
  );

  double get progress => target <= 0 ? 0 : (collected / target).clamp(0, 1);
  int get daysLeft => deadline.difference(DateTime.now()).inDays.clamp(0, 9999);

  CampaignModel withDonation(double amount) => CampaignModel(
    id: id,
    title: title,
    location: location,
    type: type,
    description: description,
    organizer: organizer,
    target: target,
    collected: collected + amount,
    donors: donors + 1,
    deadline: deadline,
    verified: verified,
    verifiedBy: verifiedBy,
    updates: updates,
    allocation: allocation,
  );
}
