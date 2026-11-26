# SiagaNusa

**SiagaNusa** adalah platform informasi, pemantauan, dan respons bencana di Indonesia yang terdiri dari aplikasi client (**Flutter**) dan layanan API (**Laravel**).

---

## Struktur Proyek

Proyek ini terbagi menjadi 2 direktori utama:

### 1. `Frontend/` (Aplikasi Flutter)
Aplikasi multi-platform (Android, iOS, Web, Desktop) berbasis **Flutter** (Dart SDK `^3.13.2`).

**Fitur Utama:**
- **Dashboard & Peringatan Dini:** Ringkasan gempa bumi 24 jam, status tsunami, dan titik panas (hotspot) secara real-time.
- **Peta Bencana Interaktif:** Visualisasi lokasi gempa, sensor seismik, titik panas karhutla, dan kualitas udara menggunakan `flutter_map`.
- **Informasi & Analisis Bencana:** Detail gempa bumi, peringatan tsunami, hotspot karhutla, serta analisis dampak dan risiko.
- **Pelaporan Masyarakat:** Pengajuan laporan kejadian bencana oleh warga beserta riwayat dan status verifikasi.
- **Donasi & Kampanye Kemanusiaan:** Daftar kampanye donasi, detail penyaluran dana, pembayaran, dan riwayat donasi.
- **Tanggap Darurat & Mitigasi:** Kontak darurat, informasi evakuasi, panduan mitigasi, dan kesiapsiagaan bencana.
- **Notifikasi & Profil:** Pusat notifikasi peringatan dini serta manajemen profil pengguna dan tema (terang/gelap).

**Menjalankan Frontend:**
```bash
cd Frontend
flutter pub get
flutter run
```

---

### 2. `Backend/` (API Laravel)
Layanan backend berbasis **Laravel** yang menyediakan autentikasi, manajemen data aplikasi, serta sinkronisasi dan caching data resmi dari **BMKG** dan **Sipongi (KLHK)**.

**Endpoint Utama (`/api`):**
- **BMKG (`/api/bmkg`):** `datagempa`, `live30event`, `last30event`, `last30feltevent`, `last30tsunamievent`, `3mgempaql`, `histori`, `katalog_gempa`, `sensors`, `spatial`, `events/mmi`.
- **Sipongi (`/api/sipongi`):** `hotspot`, `summary_hotspot`, `sebaran`, `summary_kebakaran`, `pemadaman`, `aqms`, `provinsi`, `boundaries_provinsi`.
- **Autentikasi (`/api/auth` & `/api/user`):** `register`, `login`, `logout`, `user`, `user/profile` (menggunakan Laravel Sanctum).
- **Laporan Masyarakat (`/api/reports`):** Daftar laporan, laporan milik pengguna (`/my`), detail, dan kirim laporan baru.
- **Donasi & Kampanye (`/api/campaigns` & `/api/donations`):** Daftar/detail/buat kampanye, kirim donasi, dan riwayat donasi (`/my`).
- **Notifikasi (`/api/notifications`):** Daftar notifikasi, detail, dan tandai sudah dibaca.

**Menjalankan Backend:**
```bash
cd Backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
php artisan schedule:work   # Untuk sinkronisasi otomatis feed BMKG & Sipongi
```
