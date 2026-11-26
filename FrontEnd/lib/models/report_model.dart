enum ReportStatus { pending, verifying, verified, rejected }

extension ReportStatusX on ReportStatus {
  String get label => switch (this) {
    ReportStatus.pending => 'Menunggu',
    ReportStatus.verifying => 'Diverifikasi',
    ReportStatus.verified => 'Terverifikasi',
    ReportStatus.rejected => 'Ditolak',
  };
}

class ReportModel {
  final String id;
  final String category;
  final String location;
  final String description;
  final String? photoName;
  final DateTime createdAt;
  final ReportStatus status;
  final String? note;

  const ReportModel({
    required this.id,
    required this.category,
    required this.location,
    required this.description,
    required this.createdAt,
    required this.status,
    this.photoName,
    this.note,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
    id: (json['id'] ?? '').toString(),
    category: (json['category'] ?? json['disaster_type'] ?? '').toString(),
    location: (json['location'] ?? json['location_name'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
    photoName: json['photo_name']?.toString() ?? json['image']?.toString(),
    createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ?? DateTime.now(),
    status: ReportStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ReportStatus.pending,
    ),
    note: json['note']?.toString(),
  );
}
