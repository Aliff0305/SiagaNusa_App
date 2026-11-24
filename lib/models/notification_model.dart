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
