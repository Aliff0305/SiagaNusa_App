import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Koneksi terlalu lama. Coba lagi.');
      case DioExceptionType.connectionError:
        return const ApiException(
          'Tidak dapat terhubung ke server. Periksa koneksi internet kamu.',
        );
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final data = e.response?.data;
        final msg = (data is Map && data['message'] is String)
            ? data['message'] as String
            : 'Server mengembalikan kesalahan ($code).';
        return ApiException(msg, statusCode: code);
      default:
        return const ApiException('Terjadi kesalahan jaringan.');
    }
  }

  @override
  String toString() => message;
}
