# Dokumentasi Gap API Backend — SiagaNusa

Dokumen ini berisi daftar endpoint yang dibutuhkan oleh aplikasi **SiagaNusa (Flutter)** namun **belum tersedia** di `SiagaNusaBackend` (`routes/api.php`).

---

## 1. Autentikasi (`/api/auth`)
Saat ini baru tersedia `GET /api/user` (dengan `auth:sanctum`). Endpoint untuk proses login, registrasi, dan logout belum ada.

| Method | Endpoint | Deskripsi | Kebutuhan Payload / Response |
| :--- | :--- | :--- | :--- |
| `POST` | `/api/auth/login` | Login pengguna | Body: `email`, `password` → Response: `token` (Sanctum), `user` |
| `POST` | `/api/auth/register` | Registrasi pengguna baru | Body: `name`, `email`, `password`, `phone` (opsional) → Response: `token`, `user` |
| `POST` | `/api/auth/logout` | Logout / hapus token aktif | Header: `Authorization: Bearer <token>` |
| `PUT` | `/api/user/profile` | Update profil pengguna | Body: `name`, `phone`, `avatar` (opsional) |

---

## 2. Laporan Masyarakat (`/api/reports`)
Dibutuhkan untuk fitur pelaporan kejadian bencana oleh pengguna (`report_screen.dart`, `create_report_screen.dart`, `report_history_screen.dart`).

| Method | Endpoint | Deskripsi | Kebutuhan Payload / Response |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/reports` | Daftar semua laporan bencana | Query opsional: `status`, `type`, `page` |
| `GET` | `/api/reports/my` | Riwayat laporan milik user yang login | Membutuhkan `auth:sanctum` |
| `GET` | `/api/reports/{id}` | Detail satu laporan | — |
| `POST` | `/api/reports` | Kirim laporan bencana baru | Multipart/JSON: `title`, `description`, `disaster_type`, `latitude`, `longitude`, `location_name`, `image` (file) |

---

## 3. Donasi & Kampanye (`/api/campaigns` & `/api/donations`)
Dibutuhkan untuk fitur penggalangan dana dan donasi (`donation_screen.dart`, `campaign_detail_screen.dart`, `create_campaign_screen.dart`, `donation_payment_screen.dart`, `donation_history_screen.dart`).

| Method | Endpoint | Deskripsi | Kebutuhan Payload / Response |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/campaigns` | Daftar kampanye donasi aktif | Query opsional: `category`, `status`, `page` |
| `GET` | `/api/campaigns/{id}` | Detail kampanye donasi | — |
| `POST` | `/api/campaigns` | Buat kampanye donasi baru | `title`, `description`, `target_amount`, `deadline`, `image` |
| `POST` | `/api/donations` | Kirim/buat transaksi donasi | `campaign_id`, `amount`, `payment_method`, `note` (opsional) |
| `GET` | `/api/donations/my` | Riwayat donasi user yang login | Membutuhkan `auth:sanctum` |

---

## 4. Notifikasi & Peringatan Dini (`/api/notifications`)
Dibutuhkan untuk pusat notifikasi di aplikasi (`notification_screen.dart`, `notification_detail_screen.dart`).

| Method | Endpoint | Deskripsi | Kebutuhan Payload / Response |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/notifications` | Daftar notifikasi user / peringatan dini | Membutuhkan `auth:sanctum` |
| `GET` | `/api/notifications/{id}` | Detail notifikasi | — |
| `PATCH` | `/api/notifications/{id}/read` | Tandai notifikasi sudah dibaca | — |

---

## Catatan Tambahan
- **Format Response:** Disarankan konsisten menggunakan JSON dengan struktur standar (misal `{ "data": ..., "message": "..." }`).
- **Autentikasi:** Endpoint yang berkaitan dengan data pribadi user (`/my`, `POST`, `PUT`, `PATCH`) menggunakan middleware `auth:sanctum`.
