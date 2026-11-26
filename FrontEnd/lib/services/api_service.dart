import 'package:siaganusa/core/network/api_client.dart';

/// Pembungkus tipis ApiClient. Semua service memakai kelas ini
/// saat ApiConstants.useMock = false.
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final ApiClient _client = ApiClient.instance;

  void setToken(String? token) => _client.setToken(token);

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _client.get(path, query: query);

  Future<dynamic> post(String path, {Object? data}) =>
      _client.post(path, data: data);

  Future<dynamic> put(String path, {Object? data}) =>
      _client.put(path, data: data);

  Future<dynamic> patch(String path, {Object? data}) =>
      _client.patch(path, data: data);

  /// Ambil list dari respons. Bentuk respons backend BELUM final:
  /// mendukung `[...]` maupun `{ "data": [...] }`.
  List<Map<String, dynamic>> asList(dynamic body) {
    final raw = body is Map ? body['data'] : body;
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }
}
