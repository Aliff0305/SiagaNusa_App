import 'package:flutter/foundation.dart';
import 'package:siaganusa/models/notification_model.dart';
import 'package:siaganusa/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> _items = [];
  bool _loading = false;
  bool _loaded = false;

  List<NotificationModel> get items => _items;
  bool get isLoading => _loading;
  int get unreadCount => _items.where((n) => !n.isRead).length;

  Future<void> load({bool force = false}) async {
    if (_loading || (_loaded && !force)) return;
    _loading = true;
    notifyListeners();
    _items = await _service.fetch();
    _loaded = true;
    _loading = false;
    notifyListeners();
  }

  void markRead(String id) {
    _items = [
      for (final n in _items) n.id == id ? n.copyWith(isRead: true) : n,
    ];
    notifyListeners();
  }

  void markAllRead() {
    _items = [for (final n in _items) n.copyWith(isRead: true)];
    notifyListeners();
  }
}
