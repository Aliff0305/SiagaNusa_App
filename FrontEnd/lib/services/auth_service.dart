import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:siaganusa/core/constants/api_constants.dart';
import 'package:siaganusa/core/network/api_exception.dart';
import 'package:siaganusa/models/user_model.dart';
import 'package:siaganusa/services/api_service.dart';

class AuthService {
  static const _kUser = 'auth_user';
  static const _kToken = 'auth_token';

  Future<UserModel?> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null) return null;
    ApiService.instance.setToken(prefs.getString(_kToken));
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<UserModel> login(String email, String password) async {
    if (ApiConstants.useMock) {
      await Future.delayed(const Duration(milliseconds: 800));
      final name = email.split('@').first;
      final user = UserModel(
        id: '1',
        name: name.isEmpty ? 'Pengguna' : _title(name),
        email: email,
        city: 'Surabaya',
      );
      await _save(user, 'mock-token');
      return user;
    }
    final body = await ApiService.instance.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return _fromAuthBody(body);
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (ApiConstants.useMock) {
      await Future.delayed(const Duration(milliseconds: 900));
      final user = UserModel(id: '1', name: name, email: email, phone: phone);
      await _save(user, 'mock-token');
      return user;
    }
    final body = await ApiService.instance.post(
      ApiConstants.register,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return _fromAuthBody(body);
  }
  
  /// Simpan data profil terbaru. Saat backend aktif, panggil endpoint update profil.
  Future<void> saveUser(UserModel user) async {
    if (!ApiConstants.useMock) {
      await ApiService.instance.put(
        ApiConstants.userProfile,
        data: {'name': user.name, 'phone': user.phone, 'city': user.city},
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    if (!ApiConstants.useMock) {
      try {
        await ApiService.instance.post(ApiConstants.logout);
      } catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUser);
    await prefs.remove(_kToken);
    ApiService.instance.setToken(null);
  }

  /// Bentuk respons backend belum final. Sesuaikan saat Laravel jadi.
  Future<UserModel> _fromAuthBody(dynamic body) async {
    if (body is! Map) throw const ApiException('Respons server tidak valid.');
    final user = UserModel.fromJson(body['user'] as Map<String, dynamic>);
    await _save(user, '${body['token']}');
    return user;
  }

  Future<void> _save(UserModel user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUser, jsonEncode(user.toJson()));
    await prefs.setString(_kToken, token);
    ApiService.instance.setToken(token);
  }

  String _title(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
