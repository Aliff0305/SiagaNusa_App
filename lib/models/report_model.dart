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
}
