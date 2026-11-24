import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  /// true  = semua data memakai data contoh (mock) di dalam service.
  /// false = service memanggil backend Laravel (belum dibuat).
  static const bool useMock = true;

  /// Android emulator memakai 10.0.2.2 untuk mengakses localhost komputer.
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api';

  // Endpoint backend Laravel (rencana, akan disesuaikan saat backend dibuat)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String earthquakes = '/earthquakes';
  static const String tsunamis = '/tsunamis';
  static const String hotspots = '/hotspots';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String campaigns = '/campaigns';
  static const String donations = '/donations';

  // Halaman sumber data resmi. Format respons API BELUM diverifikasi.
  static const String bmkgDocs = 'https://data.bmkg.go.id/gempabumi/';
  static const String inatewsSite = 'https://inatews.bmkg.go.id/';
  static const String sipongiSite = 'https://sipongi.gakkum.kehutanan.go.id/';
}
