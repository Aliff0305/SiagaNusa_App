import 'package:flutter/foundation.dart';
import 'package:siaganusa/core/network/api_exception.dart';
import 'package:siaganusa/models/user_model.dart';
import 'package:siaganusa/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> init() async {
    _user = await _service.restoreSession();
    notifyListeners();
  }

  Future<bool> login(String email, String password) =>
      _run(() => _service.login(email, password));

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) => _run(
    () => _service.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    ),
  );

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String city,
  }) async {
    final u = _user;
    if (u == null) return;
    _user = UserModel(
      id: u.id,
      name: name,
      email: u.email,
      phone: phone,
      city: city,
    );
    await _service.saveUser(_user!);
    notifyListeners();
  }
  
  Future<void> logout() async {
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  Future<bool> _run(Future<UserModel> Function() action) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Terjadi kesalahan. Coba lagi.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
