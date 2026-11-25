import 'package:siaganusa/models/disaster_model.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DisasterType type;
  final Severity severity;
  final DateTime time;
  final bool isRead;
  final String source;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.severity,
    required this.time,
    required this.source,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: (json['id'] ?? '').toString(),
        title: (json['title'] ?? '').toString(),
        body: (json['body'] ?? json['message'] ?? '').toString(),
        type: DisasterType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => DisasterType.earthquake,
        ),
        severity: Severity.values.firstWhere(
          (e) => e.name == json['severity'],
          orElse: () => Severity.moderate,
        ),
        time: DateTime.tryParse((json['time'] ?? json['created_at'] ?? '').toString()) ??
            DateTime.now(),
        source: (json['source'] ?? 'SiagaNusa').toString(),
        isRead: json['is_read'] == true || json['isRead'] == true,
      );

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    id: id,
    title: title,
    body: body,
    type: type,
    severity: severity,
    time: time,
    source: source,
    isRead: isRead ?? this.isRead,
  );
}
