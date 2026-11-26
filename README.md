# SiagaNusa

**SiagaNusa** adalah platform informasi, pemantauan, dan respons bencana di Indonesia yang terdiri dari aplikasi client (**Flutter**), layanan API (**Laravel**), dan skema **Database** relasional.

---

## Struktur Proyek

```text
SiagaNusa/
├── Frontend/   # Aplikasi mobile & web berbasis Flutter
├── Backend/    # REST API & sinkronisasi data BMKG/Sipongi berbasis Laravel
└── Database/   # Skema SQL (schema.sql) dan dokumentasi ERD
```

### 1. `Frontend/` (Aplikasi Flutter)
Aplikasi multi-platform (Android, iOS, Web, Desktop) berbasis **Flutter**.
- **Dashboard & Peringatan Dini:** Ringkasan gempa bumi 24 jam, status tsunami, dan titik panas (hotspot) secara real-time.
- **Peta Bencana Interaktif:** Visualisasi lokasi gempa, sensor seismik, titik panas karhutla, dan kualitas udara (`flutter_map`).
- **Informasi & Analisis Bencana:** Detail gempa bumi, peringatan tsunami, hotspot karhutla, serta analisis dampak dan risiko.
- **Pelaporan Masyarakat, Donasi, Tanggap Darurat & Mitigasi, Notifikasi, Profil.**

### 2. `Backend/` (API Laravel)
Layanan backend berbasis **Laravel** yang menyediakan autentikasi (Sanctum), manajemen data aplikasi, serta sinkronisasi dan caching data resmi dari **BMKG** dan **Sipongi (KLHK)**.
- **BMKG (`/api/bmkg`):** `datagempa`, `live30event`, `last30event`, `last30feltevent`, `last30tsunamievent`, `3mgempaql`, `histori`, `katalog_gempa`, `sensors`, `spatial`, `events/mmi`.
- **Sipongi (`/api/sipongi`):** `hotspot`, `summary_hotspot`, `sebaran`, `summary_kebakaran`, `pemadaman`, `aqms`, `provinsi`, `boundaries_provinsi`.
- **Fitur Aplikasi:** `/api/auth/*`, `/api/user`, `/api/reports/*`, `/api/campaigns/*`, `/api/donations/*`, `/api/notifications/*`.

### 3. `Database/` (Skema & ERD)
Berisi dokumentasi struktur database yang digunakan oleh `Backend/`:
- [`Database/schema.sql`](./Database/schema.sql) — DDL SQL untuk tabel `users`, `personal_access_tokens`, `reports`, `campaigns`, `donations`, dan `app_notifications`.
- [`Database/README.md`](./Database/README.md) — Entity Relationship Diagram (ERD) dan penjelasan relasi antar tabel.

---

## Requirements (Prasyarat)

Pastikan lingkungan pengembangan Anda sudah terpasang:
- **Flutter SDK** & **Dart SDK** (`^3.13.2`)
- **PHP** (`>= 8.2`) & **Composer**
- **Database:** MySQL / MariaDB (atau SQLite untuk pengembangan lokal)
- **Web Server / Local Environment:** Laragon / XAMPP / Valet (opsional)
- **Git**

---

## Panduan Instalasi & Menjalankan

### 1. Clone Repository
```bash
git clone https://github.com/Aliff0305/SiagaNusa_App.git
cd SiagaNusa_App
```

### 2. Setup Database & Backend (`Backend/`)
```bash
cd Backend
composer install
cp .env.example .env
php artisan key:generate
```
Atur koneksi database di file `Backend/.env` (`DB_CONNECTION`, `DB_HOST`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`), lalu jalankan migrasi:
```bash
php artisan migrate
```
*(Opsional: Anda juga dapat mengimpor [`Database/schema.sql`](./Database/schema.sql) secara manual jika diperlukan.)*

Jalankan server API dan scheduler untuk sinkronisasi feed BMKG & Sipongi:
```bash
php artisan serve
# Di terminal terpisah:
php artisan schedule:work
```

### 3. Setup & Jalankan Frontend (`Frontend/`)
Pastikan `baseUrl` di `Frontend/lib/core/constants/api_constants.dart` mengarah ke server backend (`http://localhost:8000/api` untuk Web atau `http://10.0.2.2:8000/api` untuk Android Emulator).
```bash
cd Frontend
flutter pub get
flutter run
```
