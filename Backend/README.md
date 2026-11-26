# SiagaNusa Backend

Gateway API berbasis **Laravel 13** untuk agregasi, caching lokal, dan sinkronisasi latar belakang (background sync) data kebencanaan dari **BMKG**, **InaTEWS**, dan **Sipongi (KLHK)**.

## Fitur Utama
- **Conditional Cache + Background Sync**: Menggunakan `ETag`, `Last-Modified`, dan hash `sha256` agar cache hanya diperbarui saat data berubah.
- **Integrasi BMKG & InaTEWS**: Data gempa real-time (`datagempa`, `live30event`, `last30event`, `last30feltevent`, `last30tsunamievent`, `3mgempaQL`), katalog/histori, sensor seismik, peta patahan aktif (`GeoJSON`), dan daftar stasiun MMI.
- **Integrasi Sipongi (Kebakaran & Hotspot)**: Data titik panas (`indoHotspot`), ringkasan hotspot, sebaran, statistik kebakaran, operasi pemadaman, kualitas udara (`aqms`), dan batas administratif.
- **Dokumentasi & Playbook**:
  - `/` — Halaman informasi sistem
  - `/docs` — Dokumentasi endpoint API
  - `/playbook` — Uji coba API interaktif langsung dari browser

## Endpoint API

### 1. BMKG & InaTEWS (Gempa & Tsunami)
- `GET /api/bmkg` — Daftar semua feed BMKG & status sync (opsional: `?category=realtime|catalog|sensor|spatial|event_detail`)
- `GET /api/bmkg/realtime` — Gabungan feed gempa real-time (`datagempa`, `live30event`, `last30event`, `last30feltevent`, `last30tsunamievent`, `3mgempaql`)
- `GET /api/bmkg/catalog` — Histori & katalog gempa (`histori`, `katalog_gempa`)
- `GET /api/bmkg/sensors` — Sensor seismik nasional & global (`sensor_seismic`, `sensor_global`)
- `GET /api/bmkg/spatial` — Data geospasial patahan aktif (`merged_fault`)
- `GET /api/bmkg/events/mmi` — Daftar stasiun & intensitas MMI (`stationlist_mmi`)
- `GET /api/bmkg/{feed}` — Feed BMKG spesifik berdasarkan key

### 2. Sipongi (Kebakaran Hutan & Hotspot)
- `GET /api/sipongi` — Daftar semua feed Sipongi & status sync (opsional: `?category=hotspot|statistics|operations|environment|reference|spatial`)
- `GET /api/sipongi/hotspot` — Titik panas (hotspot) Indonesia 24 jam terakhir (GeoJSON)
- `GET /api/sipongi/summary_hotspot` — Ringkasan jumlah hotspot per satelit & confidence level
- `GET /api/sipongi/sebaran` — Daftar tabular sebaran titik panas 24 jam terakhir
- `GET /api/sipongi/summary_kebakaran` — Ringkasan statistik luas kebakaran & penanganan tahunan
- `GET /api/sipongi/pemadaman` — Data operasi pemadaman Manggala Agni (GeoJSON)
- `GET /api/sipongi/aqms` — Data stasiun kualitas udara / IKU (GeoJSON)
- `GET /api/sipongi/provinsi` — Daftar referensi provinsi Sipongi
- `GET /api/sipongi/boundaries_provinsi` — Batas administratif provinsi Indonesia (GeoJSON)

### 3. Autentikasi, Laporan, Donasi & Notifikasi
- `POST /api/auth/register` — Registrasi pengguna baru
- `POST /api/auth/login` — Login pengguna (mengembalikan token Sanctum)
- `POST /api/auth/logout` — Logout (`auth:sanctum`)
- `PUT /api/user/profile` — Update profil pengguna (`auth:sanctum`)
- `GET /api/reports` — Daftar laporan bencana
- `GET /api/reports/my` — Riwayat laporan milik user (`auth:sanctum`)
- `GET /api/reports/{id}` — Detail laporan
- `POST /api/reports` — Kirim laporan bencana baru (`auth:sanctum`)
- `GET /api/campaigns` — Daftar kampanye donasi
- `GET /api/campaigns/{id}` — Detail kampanye donasi
- `POST /api/campaigns` — Buat kampanye donasi (`auth:sanctum`)
- `POST /api/donations` — Kirim transaksi donasi (`auth:sanctum`)
- `GET /api/donations/my` — Riwayat donasi milik user (`auth:sanctum`)
- `GET /api/notifications` — Daftar notifikasi & peringatan dini (`auth:sanctum`)
- `GET /api/notifications/{id}` — Detail notifikasi (`auth:sanctum`)
- `PATCH /api/notifications/{id}/read` — Tandai notifikasi sudah dibaca (`auth:sanctum`)

## Menjalankan Sync
Manual lewat Artisan atau jalankan `sync-all.cmd`:
```sh
php artisan bmkg:sync
php artisan sipongi:sync
```

Untuk background sync otomatis:
```sh
php artisan queue:work
php artisan schedule:work
```
