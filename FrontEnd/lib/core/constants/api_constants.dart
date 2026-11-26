import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  /// true  = semua data memakai data contoh (mock) di dalam service.
  /// false = service memanggil backend Laravel (SiagaNusaBackend).
  static const bool useMock = false;

  /// Android emulator memakai 10.0.2.2 untuk mengakses localhost komputer.
  static String get baseUrl =>
      kIsWeb ? 'http://localhost:8000/api' : 'http://10.0.2.2:8000/api';

  // Endpoint backend Laravel (SiagaNusaBackend)
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String user = '/user';
  static const String userProfile = '/user/profile';

  // BMKG Feeds
  static const String bmkgRealtime = '/bmkg/realtime';
  static const String bmkgCatalog = '/bmkg/catalog';
  static const String bmkgSensors = '/bmkg/sensors';
  static const String bmkgSpatial = '/bmkg/spatial';
  static const String bmkgMmi = '/bmkg/events/mmi';
  static const String bmkgDatagempa = '/bmkg/datagempa';
  static const String earthquakes = bmkgDatagempa;
  static const String bmkgLive30 = '/bmkg/live30event';
  static const String bmkgFelt30 = '/bmkg/last30feltevent';
  static const String bmkgTsunami30 = '/bmkg/last30tsunamievent';
  static const String tsunamis = bmkgTsunami30;

  // Sipongi Feeds
  static const String sipongiHotspot = '/sipongi/hotspot';
  static const String hotspots = sipongiHotspot;
  static const String sipongiSummaryHotspot = '/sipongi/summary_hotspot';
  static const String sipongiSebaran = '/sipongi/sebaran';
  static const String sipongiSummaryKebakaran = '/sipongi/summary_kebakaran';
  static const String sipongiPemadaman = '/sipongi/pemadaman';
  static const String sipongiAqms = '/sipongi/aqms';
  static const String sipongiBoundariesProvinsi = '/sipongi/boundaries_provinsi';

  // Fitur Aplikasi
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String myReports = '/reports/my';
  static const String campaigns = '/campaigns';
  static const String donations = '/donations';
  static const String myDonations = '/donations/my';

  // Halaman sumber data resmi. Format respons API BELUM diverifikasi.
  static const String bmkgDocs = 'https://data.bmkg.go.id/gempabumi/';
  static const String inatewsSite = 'https://inatews.bmkg.go.id/';
  static const String sipongiSite = 'https://sipongi.gakkum.kehutanan.go.id/';
}
